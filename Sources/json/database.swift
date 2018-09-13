import SQLite
import Foundation

class Database {

    var db: Connection? = nil
    let products = Table("Products")
    let categories = Table("Categories")

    func setDBName(dbName: String) {
        do {
            db = try Connection(dbName)
        } catch {
            print("Not connected")
        }
    }

    func createStructure() {
        let categories:String = "CREATE TABLE Categories(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT);"
        let products:String   = "CREATE TABLE Products(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, startingPrice TEXT, imageURL TEXT, discoverURL TEXT, category INTEGER, FOREIGN KEY(category) REFERENCES Categories(id));"
        do {
            try db!.run(categories)
            try db!.run(products)
        } catch {
            print("Database structure issue")
        }

    }

    func addProduct(product:Array<String>) {
        let title: String = product[0]
        let description: String = product[1]
        let category: String = product[2]
        let startingPrice: String = product[3]
        let imageURL: String = product[4]
        let discoverURL: String = product[5]

        let query: String = "INSERT INTO Products(title,description,category,startingPrice,imageURL,discoverURL) VALUES('\(title)','\(description)','\(category)','\(startingPrice)','\(imageURL)','\(discoverURL)');"
        do {
            try db!.run(query)
        } catch {
            print("Couldn't added products")
        }
    }

    func addCategory(category:Array<String>) {
        let title: String = category[0]
        let query: String = "INSERT INTO Categories(title) VALUES('\(title)');"
        do {
            try db!.run(query)
        } catch {
            print("Couldn't added categories")
        }
    }

    func addMockData(productsPath:String, categoriesPath: String) {
        let current = FileManager.default.currentDirectoryPath

        let categoriesPathURL = URL(fileURLWithPath: (NSString(string: current+"/Sources/json/"+categoriesPath).expandingTildeInPath ))
        let productsPathURL = URL(fileURLWithPath: (NSString(string: current+"/Sources/json/"+productsPath).expandingTildeInPath ))

        do {
            let categoriesCSV = try String(contentsOf: categoriesPathURL, encoding: .utf8)
            categoriesCSV.enumerateLines { line, _ in
                let category = line.components(separatedBy:",")
                self.addCategory(category: category)
            }
            let productsCSV = try String(contentsOf: productsPathURL, encoding: .utf8)
            productsCSV.enumerateLines { line, _ in
                let product = line.components(separatedBy:",")
                self.addProduct(product:product)
            }
        }
        catch {
            print("Unable to read the mock file")
        }

    }

    func getProducts() -> String{
        let query = "SELECT * FROM Products;"

        do {
            let stmt = try db!.prepare(query)
            var products: Array<Dictionary<String,String>> = []

            for row in stmt {
                let product_id: String = "\(row[0]!)"
                let title: String = "\(row[1]!)"
                let desc: String = "\(row[2]!)"
                let category_id: String = "\(row[6]!)"
                let startingPrice: String = "\(row[3]!)"
                let imageURL: String = "\(row[4]!)"
                let discoverURL: String = "\(row[5]!)"

                let product = [
                    "id": product_id,
                    "title": title,
                    "description": desc ,
                    "category": category_id,
                    "startingPrice": startingPrice,
                    "imageURL": imageURL,
                    "discoverURL": discoverURL
                ]
                products.append(product)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: products, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString!
        } catch {
            print("No products?")
        }
        return "No JSON generated"
    }

    func getCategories() -> String{
        let query = "SELECT * FROM Categories;"

        do {
            let stmt = try db!.prepare(query)
            var categories: Array<Dictionary<String,String>> = []

            for row in stmt {
                let category_id: String = "\(row[0]!)"
                let title: String = "\(row[1]!)"

                let category = ["id": category_id, "title": title]
                categories.append(category)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: categories, options: .prettyPrinted)
            let jsonString = String(data: jsonData,
                                    encoding: .utf8)
            return jsonString!
        } catch {
            print("No categories?")
        }
        return "No JSON generated"
    }

    func getProductByID(id: String) -> String {
        let query = "SELECT * FROM Products WHERE id = \(id);"
        do {
            let stmt = try db!.prepare(query)
            var products: Array<Dictionary<String,String>> = []

            for row in stmt {
                let category_id: String = "\(row[3]!)"
                let product_id: String = "\(row[0]!)"
                let desc: String = "\(row[2]!)"
                let title: String = "\(row[1]!)"

                let product = ["id": product_id, "title": title,"description": desc ,"category": category_id]
                products.append(product)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: products, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString!

        } catch {
            print("Problem getting product for id \(id)")
        }
        return "No JSON generated"
    }

    func getCategoryByID(id: String) -> String {
        let query = "SELECT * FROM Categories WHERE id = \(id);"
        do {
            let stmt = try db!.prepare(query)
            var categories: Array<Dictionary<String,String>> = []

            for row in stmt {
                let category_id: String = "\(row[0]!)"
                let title: String = "\(row[1]!)"

                let category = ["id": category_id, "title": title]
                categories.append(category)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: categories, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString!

        } catch {
            print("Problem getting category for id \(id)")
        }
        return "No JSON generated"
    }


}
