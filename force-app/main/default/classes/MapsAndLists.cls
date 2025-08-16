public with sharing class MapsAndLists {

  /* Populate object map using Key as concatenated string
     Result : CPU timeout, Heap size - 19.28 MB*/
  public static void approachOne() {
    // The map of enitities
    Map<String, Entity> entities = new Map<String, Entity>();

    // Populate the map with a few for loops
    for(Integer x=0;x<65;x++){
        for(Integer y=0;y<65;y++){
            for(Integer z=0;z<65;z++){
                entities.put(x + '_' + y + '_' + z, new Entity(x,y,z));
            }
        }
    }

    // Read the map with a few for loops
    for(Integer x=0;x<65;x++){
        for(Integer y=0;y<65;y++){
            for(Integer z=0;z<65;z++){
                Entity e = entities.get(x + '_' + y + '_' + z);
            }
        }
    }
  }

  /*Populate object using pre-generated string array
    Result : Heap size - 19.26 MB*/
  public static void approachTwo() {
    Map<String, Entity> entities = new Map<String, Entity>();
    String[] numbersAsString = new String[]{};

    for (Integer i = 0; i < 65; i++) {
      numbersAsString.add('_'+i);
    }

    for (Integer x = 0; x < 65; x++) {
      for (Integer y = 0; y < 65; y++) {
        for (Integer z = 0; z < 65; z++) {
          entities.put(numbersAsString[x] +
          numbersAsString[y] +
          numbersAsString[z],
          new Entity(x, y, z));
        }
      }
    }
  }

  /*Populate object using 3D array
    Result : Heap size - 42 MB*/
  public static void approachThree() {
    Integer numX = 99;
    Integer numY = 99;
    Integer numZ = 99;
    Entity[][][] entities = new Entity[][][]{};

    for(Integer x=0; x < numX; x++){

      // Add a column / row array
      entities.add(new Entity[][]{});

      for(Integer y=0; y < numY; y++) {

          // Add a column array for each row
          entities[x].add(new Entity[]{});

          for(Integer z=0; z < numZ; z++) {
              entities[x][y].add(new Entity(x,y,z));
          }
        }
      }

      // Read the array value
      for(Integer x = 0; x < numX; x++){
          for(Integer y=0; y < numY; y++){
              for(Integer z = 0; z < numZ; z++){
                  Entity e = entities[x][y][z];
              }
          }
      }
  }

}