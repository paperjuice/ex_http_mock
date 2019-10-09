# ExHttpMock

### Description
ExHttpMock is a simple http mocking service that is able to respond to http requests with responses defined by you in `.yml` files.

### Usage
#### Start container
As a stand alone Docker container. Run in the directory who's going to use ExHttpMock:
```bash
$ docker pull paperjuice/ex_http_mock:0.1.0
$ docker run -it --rm -v $PWD<mock-path>:/mocks -p 9997:9997 -d paperjuice/ex_http_mock:0.1.0
```

`<mock-path>` - is the path where you will define your `.yml` files. Right now you can only crate files in the directory at path. In the future you will be able to have nested directories with files.

As part of docker-compose.yml:
```yml
version: "3.7"

services:
  some_service:
    ...

   ex_http_mock:
    container_name: "http_mock"
    image: "paperjuice/ex_http_mock"
    tty: true
    stdin_open: true
    networks:
      - some_service
    volumes:
      - $PWD/priv/mocks:/mocks
    ports:
      - "9997:9997"

networks:
  some_service:
    driver: "bridge"
    name: some_service
```

#### YML file
You are able to define `.yml`/`.yaml` files at `<mock-path>`. The format is at follows:
```yml
---
request:
  method: POST
  path: "/login"
response:
  statusCode: 200
  headers:
    Content-Type:
    - application/json
    - charset=UTF-8
  body:
    session: "bda0be92-4ff4-48b5-a7ba-8f4803d5777a"
    expires_at: "<%= DateTime.utc_now() |> DateTime.to_unix(:second) |> Kernel.+(6000) %>"
```

Under `response, body:` you define the data that will be send back to whoever made the request.

For now there are no predefined functions for generating random data but any valid Elixir expression can be passed within the templating syntax. It get evaluated and send back in the response. The above file will return:
```json
{
  "session":"bda0be92-4ff4-48b5-a7ba-8f4803d5777a",
  "expires_at":"1570615304"
}
```

