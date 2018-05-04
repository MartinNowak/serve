import vibe.core.core, vibe.core.args, vibe.http.fileserver, vibe.http.server, vibe.inet.url;
import vibe.stream.tls : createTLSContext, TLSContextKind;
import std.file, std.getopt, std.path, std.process, std.stdio, std.string;

int main()
{
    scope settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["127.0.0.1"];
    bool help;
    readOption("bind|b", &settings.bindAddresses[0],
        "Sets the address used for serving. (default 127.0.0.1)");
    readOption("port|p", &settings.port, "Sets the port used for serving. (default 8080)");
    version (VibeNoSSL) {}
    else
    {
        string pem;
        if (readOption("https-crt", &pem, "Serve over http using the given combined PEM TLS certificate/key file."))
        {
            settings.tlsContext = createTLSContext(TLSContextKind.server);
            settings.tlsContext.useCertificateChainFile(pem);
            settings.tlsContext.usePrivateKeyFile(pem);
        }
    }

    // returns false if a help screen has been requested and displayed (--help)
    string[] args;
    if (!finalizeCommandLineOptions(&args))
        return 0;

    auto path = args.length > 1 ? args[1] : ".";

    if (path.isDir)
    {
        writefln("serving '%s'", path);
        listenHTTP(settings, serveStaticFiles(path));
    }
    else
    {
        path = path.absolutePath.buildNormalizedPath;
        auto folder = path.dirName;
        writefln("serving '%s'", folder.relativePath);
        listenHTTP(settings, serveStaticFiles(folder));

        if (path.extension == ".html")
        {
            auto url = URL("http", settings.bindAddresses[0], settings.port,
                Path(path.chompPrefix(folder)));
            writefln("opening %s in a browser", url);
            browse(url.toString());
        }
    }

    lowerPrivileges();
    return runEventLoop();
}
