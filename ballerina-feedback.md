I seriously love the FP aspects of this language!!

# Error Handling 

Union types (`|`) and nil/error lifting are amazing. They fit really well with `match`. 

But what's up with `try/catch/finally`? Did these need to be carried over b/c of JVM bytecode. Don't know enough about it. Removing would be **huge** for FP

# Matches / Assignment

- The lang has a lot of great FP traits
- It would be a great win if you could assign variables based on `match` and 
`if`/`else` statements like this:

    ```ballerina
    error|string aThing = getThing();
    var anotherThing = match aThing{
        error e => string`something isn't right! {{ e.message }}`;
        string s => s;
    }
    ```
    
    ...or this for the `if`/`else` statements:

    ```ballerina
    var filename = getFilename();
    string|error contentType = if(filename.hasSuffix(".html")) {
        "text/html";
    } else if (filename.hasSuffix(".png")) {
        "image/png";
    } else {
        KeyNotFoundError err = {message: "unknown file suffix"};
        err;
    }
    ```
# Functions

- Can `return` be optional?
    - If so, then you can use it to bail immediately
    - Or if you don't use it then the last statement of the function is the return value
    - This is a little thing that _really_ encourages FP style programming, from Scala experience
  
# General Purpose Language

- I still haven't been able to figure out how to read an entire file, aside from buffering
    - Surely there's a higher level func than `read()`ing into a buffer?
    - Something like `ioutil.ReadFile` in Go
- I still don't really get how to call an external function from inside a `service`
- I found it confusing that there's a `main` and also `service`s as entrypoints
    - I think it should make a choice between being a "services" (network servers, etc...) language and a general purpose lang
