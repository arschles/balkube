// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;

@http:ServiceConfig{ basePath: "/" }
service<http:Service> slides bind { port: 9090 } {
    @http:ResourceConfig{
        methods: ["GET"],
        path: "/",
        produces: ["text/html"]
    }
    index(endpoint caller, http:Request request) {
        http:Response response = new;
        response.setFileAsPayload("./slides/index.html", contentType = "text/html");
        _ = caller -> respond(response);
    }

    @http:ResourceConfig{
        methods: ["GET"],
        path: "/{name}",
        produces: ["text/html"]
    }
    show(endpoint caller, http:Request request, string name) {
        var filename = untaint name;
        if (lengthof filename == 0) {
            filename = "index.html";
        }
        http:Response response = new;
        try {
            response.setFileAsPayload(string `./slides/{{ filename }}`, contentType = "text/html");
        } catch (error err) {
            io:println(string `error! {{ err.message }}`);
        }
    
        _ = caller -> respond(response);
    }
}
