# Nominatim data API Swift client library

[Nominatim](https://nominatim.org/release-docs/develop/) is a tool to search OpenStreetMap (OSM) data by name and address and to generate synthetic addresses of OSM points (reverse geocoding).

For example, the Nominatim **search** API allows you to look up a 
location from a textual description or address. 
Similarly, the Nominatim **reverse** geocoding generates an 
address from a coordinate given as latitude and longitude.

**NominatimSwift** is a small Swift library to connect to the [Nominatim](https://nominatim.org/release-docs/develop/api/Overview/) server.
        
**NominatimSwift** caters for JSON responses.
          
                                                                    
### Usage

**NominatimSwift** is made easy to use with **SwiftUI**.
It can be used with the following OS:

- iOS 17.0+
- iPadOS 17.0+
- macOS 14.0+
- Mac Catalyst 17.0+

#### Examples

[Nominatim](https://nominatim.org/release-docs/develop/api/Overview/) data can be accessed through the use of a **NomiJsonProvider**, with simple functions.

```swift
let dataProvider = NomiJsonProvider()

// using the Swift async/await concurrency, eg in .task{...}
    do {
        let place: NominatimPlace = try await dataProvider.reverse(lat: 35.6768601, lon: 139.7638947, options: NomiOptions())
        print(place)
    } catch {
        print(error)
    }
    
    
// or using the callback style, eg in .onAppear {...}
    dataProvider.reverse(lat: 35.6768601, lon: 139.7638947, options: NomiOptions()) { result in
           print(result)
    }


```

#### SwiftUI data model

Using the @Observable data model **NomiDataJsonModel**


```swift
import SwiftUI
import MapKit
import NominatimSwift

            struct ContentView: View {
                let dataModel = NomiDataJsonModel()

                var body: some View {
                    VStack {
                        if dataModel.isLoading {
                            ProgressView()
                        }
                        Map {
                            ForEach(dataModel.searchResults) { place in
                                if let coord = place.coordinate2D() {
                                    Marker(place.displayName, systemImage: "globe", coordinate: coord)
                                }
                            }
                        }
                    }
                    .task {
                        dataModel.isLoading = true
                        await dataModel.search(address: "Sydney, Australia", options: NomiOptions())
                        dataModel.isLoading = false
                    }
                }
                
            }
```


For bulk parallel processing, use **NomiBatchJsonModel** for JSON geocoding in batch mode.


### Options

Options available:

See **NomiOptions**
            
-   see [Nominatim](https://nominatim.org/release-docs/develop/api/Overview/) for all the optional parameters available.

### Installation

Include the files in the **./Sources/NominatimSwift** folder into your project or preferably use **Swift Package Manager**.

#### Swift Package Manager (SPM)

Create a Package.swift file for your project and add a dependency to:

```swift
dependencies: [
  .package(url: "https://github.com/workingDog/NominatimSwift.git", branch: "main")
]
```

#### Using Xcode

    Select your project > Swift Packages > Add Package Dependency...
    https://github.com/workingDog/NominatimSwift.git

Then in your code:

```swift
import NominatimSwift
```
    
### References

-    [Nominatim](https://nominatim.org/release-docs/develop/api/Overview/)

### License

MIT

