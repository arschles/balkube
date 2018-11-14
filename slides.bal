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
        http:Response response = new;

        var filename = untaint name;
        io:ReadableByteChannel byteChannel = io:openReadableFile("./slides/" + filename);
        io:ReadableCharacterChannel charChannel = new(byteChannel, "UTF-8");

        

        if filename.hasSuffix(".html") {
            match charChannel.readXml() {
                error err => {
                    string s = untaint string`Couldn't read file {{ filename }}: {{ err.message }}`;
                    response.setTextPayload(s, contentType="text/plain");// but {
                    //     error e => io:println(string `error with file ./slides/{{ filename }}. {{ err.message }}`);
                    //     () => 
                    // }
                }
                xml resp => {
                    try {
                        response.setXmlPayload(untaint resp, contentType = "text/html");
                        // response.setFileAsPayload(string `./slides/{{ filename }}`, contentType = "text/html");
                    } catch (error err) {
                        io:println(string `error with file ./slides/{{ filename }}. {{ err.message }}`);
                        response.statusCode = 404;
                    }
                }
            }
        } else {
            string cType;
            if (filename.hasSuffix(".png")) {
                cType = "image/png";
            } else if (filename.hasSuffix(".jpg") || filename.hasSuffix(".jpeg")) {
                cType = "image/jpeg";
            }
            try {
                response.setFileAsPayload(string`./slides/{{ filename }}`, contentType = cType);
            } catch (error err) {
                io:println(string`error with file ./slides/{{ filename }}. {{ err.message }}`);
                response.statusCode = 404;
            }
        }
    
        _ = caller -> respond(response);

        match charChannel.close() {
            error e => {}
            () => {}
        }
        match byteChannel.close() {
            error e => {}
            () => {}
        }
    }
}
