#!/usr/bin/env bash

echo "Make sure you're in the root of the repository"
read -r -p "Is web-api running at http://localhost:5000/ using v1? [Y/n] " response
 if [[ $response =~ ^(Y|y| ) ]] || [[ -z $response ]]; then
    swagger-codegen generate -i http://localhost:5000/swagger/v1/swagger.json -l csharp -o GeneratedClient 
    # -c swagger_config.json
    # append the above line to generate with swagger_config.json, default config seems to work fine
    # use   
        # swagger-codegen config-help -l csharp   
    # to list configuration options

    rm -r IO.Swagger/
    mv GeneratedClient/src/IO.Swagger .
    rm -r GeneratedClient/
 fi

