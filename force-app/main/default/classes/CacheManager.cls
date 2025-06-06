public without sharing class CacheManager {
  @TestVisible
  private static final Map<String, Cacheable> CONFIGURATION_DEVELOPER_NAME_TO_CACHEABLE_INSTANCE = new Map<String, Cacheable>();
  @TestVisible
  private static final List<CacheValue__mdt> CONFIGURED_CACHE_VALUES = Schema.CacheValue__mdt.getAll().values();
  @TestVisible
  private static final String PLATFORM_CACHE_NULL_VALUE = '<{(CACHE_VALUE_IS_NULL)}>'; // Presumably, no one will ever use this as an actual value
  @TestVisible
  private static final Cache_Configuration__mdt	 ORGANIZATION_CACHE_CONFIGURATION = Cache_Configuration__mdt.getInstance('Organization').clone();
  @TestVisible
  private static final Cache_Configuration__mdt	 SESSION_CACHE_CONFIGURATION = Cache_Configuration__mdt.getInstance('Session').clone();
  @TestVisible
  private static final Cache_Configuration__mdt	 TRANSACTION_CACHE_CONFIGURATION = Cache_Configuration__mdt.getInstance('Transaction').clone();

  private static Map<PlatformCacheType, PlatformCachePartitionProxy> cacheTypeToMockPartitionProxy = new Map<PlatformCacheType, PlatformCachePartitionProxy>();

  private enum PlatformCacheType {
    ORGANIZATION,
    SESSION
  }

  public static Cacheable getOrganizationCache() {
    return getOrganizationCache(ORGANIZATION_CACHE_CONFIGURATION);
  }

  public static Cacheable getOrganizationCache(Cache_Configuration__mdt	 configuration) {
    return getPlatformCache(configuration, PlatformCacheType.ORGANIZATION);
  }

  public static Cacheable getSessionCache() {
    return getSessionCache(SESSION_CACHE_CONFIGURATION);
  }

  public static Cacheable getSessionCache(Cache_Configuration__mdt	 configuration) {
    return getPlatformCache(configuration, PlatformCacheType.SESSION);
  }

  public static Cacheable getTransactionCache() {
    if (CONFIGURATION_DEVELOPER_NAME_TO_CACHEABLE_INSTANCE.containsKey(TRANSACTION_CACHE_CONFIGURATION.DeveloperName)) {
      return CONFIGURATION_DEVELOPER_NAME_TO_CACHEABLE_INSTANCE.get(TRANSACTION_CACHE_CONFIGURATION.DeveloperName);
    }

    TransactionCache transactionCacheInstance = new TransactionCache(TRANSACTION_CACHE_CONFIGURATION);
    CONFIGURATION_DEVELOPER_NAME_TO_CACHEABLE_INSTANCE.put(TRANSACTION_CACHE_CONFIGURATION.DeveloperName, transactionCacheInstance);

    return transactionCacheInstance;
  }

  @TestVisible
  private static void setMockPartitionProxy(PlatformCacheType cacheType, PlatformCachePartitionProxy mockPartitionProxy) {
    cacheTypeToMockPartitionProxy.put(cacheType, mockPartitionProxy);
  }

  private static void validateKey(String key) {
    Pattern alphanumericPattern = Pattern.compile('^[a-zA-Z0-9]+$');
    Matcher regexMatcher = alphanumericPattern.matcher(key);
    if (regexMatcher.matches() == false) {
      throw new IllegalArgumentException('Key must be alphanumeric, received key: ' + key);
    }
  }

  private static Cacheable getPlatformCache(Cache_Configuration__mdt	 configuration, PlatformCacheType cacheType) {
    if (CONFIGURATION_DEVELOPER_NAME_TO_CACHEABLE_INSTANCE.containsKey(configuration.DeveloperName)) {
      return CONFIGURATION_DEVELOPER_NAME_TO_CACHEABLE_INSTANCE.get(configuration.DeveloperName);
    }

    PlatformCachePartitionProxy partitionProxy = new PlatformCachePartitionProxy(cacheType, configuration.PlatformCachePartitionName__c);
    if (cacheTypeToMockPartitionProxy.containsKey(cacheType)) {
      partitionProxy = cacheTypeToMockPartitionProxy.get(cacheType);
    }

    Cache_Configuration__mdt localTransactionCacheConfiguration = new Cache_Configuration__mdt	(
      IsEnabled__c = true,
      IsImmutable__c = configuration.IsImmutable__c
    );

    PlatformCache platformCache = new PlatformCache(configuration, new TransactionCache(localTransactionCacheConfiguration), partitionProxy);
    CONFIGURATION_DEVELOPER_NAME_TO_CACHEABLE_INSTANCE.put(configuration.DeveloperName, platformCache);

    return platformCache;
  }

  private static Map<String, Object> loadConfiguredCacheValues(Cache_Configuration__mdt	 cacheConfiguration) {
    Map<String, Object> keyToCacheValue = new Map<String, Object>();
    if (cacheConfiguration.IsEnabled__c == false) {
      return keyToCacheValue;
    }

    for (CacheValue__mdt configuredCacheValue : CONFIGURED_CACHE_VALUES) {
      if (configuredCacheValue.Cache__c == cacheConfiguration.Id && configuredCacheValue.IsEnabled__c == true) {
        System.Type dataType = System.Type.forName(configuredCacheValue.DataType__c);
        Boolean isString = configuredCacheValue.DataType__c == String.class.getName();
        Object castedValue = isString ? configuredCacheValue.Value__c : System.JSON.deserialize(configuredCacheValue.Value__c, dataType);
        keyToCacheValue.put(configuredCacheValue.Key__c, castedValue);
      }
    }
    return keyToCacheValue;
  }

  private class PlatformCache implements Cacheable {
    private final PlatformCachePartitionProxy cachePartitionProxy;
    private final Cache_Configuration__mdt	 configuration;
    private final TransactionCache fallbackTransactionCache;

    private PlatformCache(Cache_Configuration__mdt	 configuration, transactionCache transactionCache, PlatformCachePartitionProxy cachePartitionProxy) {
      this.configuration = configuration;
      this.fallbackTransactionCache = transactionCache;
      this.cachePartitionProxy = cachePartitionProxy;

      this.put(loadConfiguredCacheValues(this.configuration));
    }

    public Boolean contains(String key) {
      if (this.configuration.IsEnabled__c == false || this.fallbackTransactionCache.contains(key) || this.cachePartitionProxy.isAvailable() == false) {
        return this.fallbackTransactionCache.contains(key);
      } else {
        return this.cachePartitionProxy.contains(key);
      }
    }

    public Map<String, Boolean> contains(Set<String> keys) {
      Map<String, Boolean> keyToContainsResult = this.cachePartitionProxy.contains(keys);
      keyToContainsResult.putAll(this.fallbackTransactionCache.contains(keys));
      return keyToContainsResult;
    }

    public Boolean containsAll(Set<String> keys) {
      Map<String, Boolean> keyToContainsResult = this.contains(keys);
      if (keyToContainsResult == null || keyToContainsResult.isEmpty() == true) {
        return false;
      }

      for (String key : keyToContainsResult.keySet()) {
        Boolean containsKey = keyToContainsResult.get(key);
        if (containsKey == false) {
          return false;
        }
      }
      return true;
    }

    public Object get(String key) {
      if (this.fallbackTransactionCache.contains(key) || this.cachePartitionProxy.isAvailable() == false) {
        return this.fallbackTransactionCache.get(key);
      } else {
        Object value = this.cachePartitionProxy.get(key);
        // Platform cache does not support storing null values, so a predefined value is used as a substitute
        if (value == PLATFORM_CACHE_NULL_VALUE) {
          value = null;
        }
        this.fallbackTransactionCache.put(key, value);
        return value;
      }
    }

    public Map<String, Object> get(Set<String> keys) {
      Map<String, Object> keyToValue = this.cachePartitionProxy.get(keys);
      if (keyToValue == null) {
        keyToValue = new Map<String, Object>();
      }
      keyToValue.putAll(this.fallbackTransactionCache.get(keys));
      return keyToValue;
    }

    public Map<String, Object> getAll() {
      return this.get(this.getKeys());
    }

    public Set<String> getKeys() {
      Set<String> keys = this.cachePartitionProxy.getKeys();
      if (keys == null) {
        keys = new Set<String>();
      }
      keys.addAll(this.fallbackTransactionCache.getKeys());
      return keys;
    }

    public Boolean isAvailable() {
      return this.isEnabled() && this.cachePartitionProxy.isAvailable() == true;
    }

    public Boolean isEnabled() {
      return this.configuration?.IsEnabled__c == true;
    }

    public Boolean isImmutable() {
      return this.configuration?.IsImmutable__c == true;
    }

    public void put(String key, Object value) {
      if (this.isEnabled() == false) {
        return;
      }

      validateKey(key);
      this.fallbackTransactionCache.put(key, value);

      if (this.isAvailable() == true && this.isImmutable() == false || this.contains(key) == false) {
        // Platform cache does not support storing null values, so a predefined value is used as a substitute
        if (value == null) {
          value = PLATFORM_CACHE_NULL_VALUE;
        }
        Cache.Visibility visibility = Cache.Visibility.valueOf(this.configuration.PlatformCacheVisibility__c.toUpperCase());
        this.cachePartitionProxy.put(key, value, this.configuration.PlatformCacheTimeToLive__c.intValue(), visibility, this.configuration.IsImmutable__c);
      }
    }

    public void put(Map<String, Object> keyToValue) {
      for (String key : keyToValue.keySet()) {
        this.put(key, keyToValue.get(key));
      }
    }

    public void remove(String key) {
      if (this.isImmutable() == true) {
        return;
      }

      this.fallbackTransactionCache.remove(key);
      if (this.isAvailable() == true) {
        this.cachePartitionProxy.remove(key);
      }
    }

    public void remove(Set<String> keys) {
      for (String key : keys) {
        this.remove(key);
      }
    }

    public void removeAll() {
      for (String key : this.getKeys()) {
        this.remove(key);
      }
    }
  }

  @TestVisible
  private virtual class PlatformCachePartitionProxy {
    private final Cache.Partition platformCachePartition;

    protected PlatformCachePartitionProxy(PlatformCacheType cacheType, String partitionName) {
      // If the specified partition name is not found, the platform automatically throws a runtime exception, which isn't ideal.
      // It seems better to eat the exceptions & fallback to the transaction cache (which doesn't rely on Platform Cache).
      try {
        switch on cacheType {
          when ORGANIZATION {
            this.platformCachePartition = Cache.Org.getPartition(partitionName);
          }
          when SESSION {
            this.platformCachePartition = Cache.Session.getPartition(partitionName);
          }
        }
      } catch (Cache.Org.OrgCacheException orgCacheException) {
        // No-op if the partition can't be found - the rest of the code will fallback to using the transaction cache
      } catch (Cache.Session.SessionCacheException sessionCacheException) {
        // No-op if the partition can't be found - the rest of the code will fallback to using the transaction cache
      }
    }

    public virtual Boolean contains(String key) {
      return this.platformCachePartition?.contains(key) == true;
    }

    public Map<String, Boolean> contains(Set<String> keys) {
      Map<String, Boolean> keyToContainsResult = this.platformCachePartition?.contains(keys);
      if (keyToContainsResult == null) {
        keyToContainsResult = new Map<String, Boolean>();
      }
      if (keyToContainsResult.isEmpty() == true) {
        for (String key : keys) {
          keyToContainsResult.put(key, false);
        }
      }
      return keyToContainsResult;
    }

    public virtual Object get(String key) {
      return this.platformCachePartition?.get(key);
    }

    public virtual Map<String, Object> get(Set<String> keys) {
      return this.platformCachePartition?.get(keys);
    }

    public virtual Set<String> getKeys() {
      return this.platformCachePartition?.getKeys();
    }

    public virtual Boolean isAvailable() {
      return this.platformCachePartition?.isAvailable() == true;
    }

    public virtual void put(String key, Object value, Integer cacheTtlSeconds, Cache.Visibility cacheVisiblity, Boolean isCacheImmutable) {
      this.platformCachePartition?.put(key, value, cacheTtlSeconds, cacheVisiblity, isCacheImmutable);
    }

    public virtual void remove(String key) {
      this.platformCachePartition?.remove(key);
    }
  }

  private class TransactionCache implements Cacheable {
    private final Cache_Configuration__mdt	 configuration;
    private final Map<String, Object> keyToValue = new Map<String, Object>();

    private TransactionCache(Cache_Configuration__mdt	 configuration) {
      this.configuration = configuration;

      this.put(loadConfiguredCacheValues(this.configuration));
    }

    public Boolean contains(String key) {
      return this.keyToValue.containsKey(key);
    }

    public Map<String, Boolean> contains(Set<String> keys) {
      Map<String, Boolean> keyToContainsResult = new Map<String, Boolean>();
      for (String key : keys) {
        keyToContainsResult.put(key, this.contains(key));
      }
      return keyToContainsResult;
    }

    public Boolean containsAll(Set<String> keys) {
      return this.keyToValue.keySet().containsAll(keys);
    }

    public Object get(String key) {
      return this.keyToValue.get(key);
    }

    public Map<String, Object> get(Set<String> keys) {
      Map<String, Object> matchingKeyToValue = new Map<String, Object>();
      for (String key : keys) {
        matchingKeyToValue.put(key, this.get(key));
      }
      return matchingKeyToValue;
    }

    public Map<String, Object> getAll() {
      return this.keyToValue.clone();
    }

    public Set<String> getKeys() {
      return this.keyToValue.keySet();
    }

    public Boolean isAvailable() {
      return this.isEnabled() == true;
    }

    public Boolean isEnabled() {
      return this.configuration?.IsEnabled__c == true;
    }

    public Boolean isImmutable() {
      return this.configuration?.IsImmutable__c == true;
    }

    public void put(String key, Object value) {
      if (this.isEnabled() == true || (this.isImmutable() == false || this.contains(key) == false)) {
        validateKey(key);
        this.keyToValue.put(key, value);
      }
    }

    public void put(Map<String, Object> keyToValue) {
      for (String key : keyToValue.keySet()) {
        this.put(key, keyToValue.get(key));
      }
    }

    public void remove(String key) {
      if (this.isEnabled() == true && this.isImmutable() == false) {
        this.keyToValue.remove(key);
      }
    }

    public void remove(Set<String> keys) {
      for (String key : keys) {
        this.remove(key);
      }
    }

    public void removeAll() {
      if (this.isEnabled() == true && this.isImmutable() == false) {
        this.keyToValue.clear();
      }
    }
  }
}