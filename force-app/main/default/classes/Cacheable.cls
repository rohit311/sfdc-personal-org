public interface Cacheable {
  Boolean contains(String key);
  Map<String, Boolean> contains(Set<String> keys);
  Boolean containsAll(Set<String> keys);
  Object get(String key);
  Map<String, Object> get(Set<String> keys);
  Map<String, Object> getAll();
  Set<String> getKeys();
  Boolean isAvailable();
  Boolean isEnabled();
  Boolean isImmutable();
  void put(String key, Object value);
  void put(Map<String, Object> keyToValue);
  void remove(String key);
  void remove(Set<String> keys);
  void removeAll();
}
