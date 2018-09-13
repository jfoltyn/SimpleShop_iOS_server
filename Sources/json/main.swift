import PerfectHTTPServer
import PerfectHTTP
import PerfectSQLite
import Foundation

let category = Category(id: UUID(),title:"sample")

let dbName  = "mcommerce.sqlite"
let productMocks = "products.csv"
let categoryMocks = "categories.csv"

let db = Database()
db.setDBName(dbName: dbName) 
db.createStructure()
db.addMockData(productsPath: productMocks, categoriesPath: categoryMocks)

var routes = Routes()
routes.add(method: .get, uri: "/") {
	request, response in
	response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
	response.completed()
}
routes.add(method: .get, uri: "/products") {
	request, response in
	response.appendBody(string: db.getProducts())
	response.completed()
}
routes.add(method: .get, uri: "/categories") {
	request, response in
	response.appendBody(string: db.getCategories())
	response.completed()
}

func getProductById(request: HTTPRequest, response: HTTPResponse) {
	let product_id = request.urlVariables["id"] != nil
	var productJSON = "[{ \"error\" : \"No product found with this id\" }]"
	if product_id {
		productJSON = db.getProductByID(id:request.urlVariables["id"]!)
	}	
	response.appendBody(string: productJSON)
		.completed()
}
routes.add(method: .get, uri: "/product/{id}", handler: getProductById)

func getCategoryById(request: HTTPRequest, response: HTTPResponse) {
	let category_id = request.urlVariables["id"] != nil
	var categoryJSON = "[{ \"error\" : \"No category found with this id\" }]"
	if category_id {
		categoryJSON = db.getCategoryByID(id:request.urlVariables["id"]!)
	}	
	response.appendBody(string: categoryJSON)
		.completed()
}
routes.add(method: .get, uri: "/category/{id}", handler: getCategoryById)

try HTTPServer.launch(name: "ios.uj.edu.pl", port: 8000, routes: routes) 
