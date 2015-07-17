# serve [![Dub](https://img.shields.io/dub/v/serve.svg)](http://code.dlang.org/packages/serve) ![Uses vibe.d](https://img.shields.io/badge/uses-vibe.d-brightgreen.svg)
A simple HTTP server for static files.

### Installation

You can simply use dub to run the tool.

```sh
dub fetch serve
dub run serve
dub run serve -- [ARGS]
```

Or you build the tool and copy/symlink it into your path.

```sh
dub fetch serve
dub build serve
sudo mv ~/.dub/packages/serve-1.0.0/serve /usr/local/bin/
```

### Usage

- serve the current working directory

    ```sh
    serve
    ```

- serve an html file with it's containing folder and open it in your browser

    ```sh
    serve path/to/index.html
    ```

- serve a folder

    ```sh
    serve path/to/folder
    ```

- use a different port that 8080 (`-p|--port`)

    ```sh
    serve -p 1234
    ```

- bind a different IP address than 127.0.0.1 using (`-b|--bind`)

    ```sh
    serve -b 127.0.0.1
    ```

- run `-h|--help` to see all options

    ```sh
    serve -- -h
    ```
