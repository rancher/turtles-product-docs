# turtles-product-docs

Building using local playbook, UI fetching, and link validation using log-level `info`:

`npx antora --fetch turtles-local-playbook.yml --log-level info`

Build content only after initial UI fetch:

`npx antora turtles-local-playbook.yml`

Running site using local playbook:

`npx http-server build/site -c-1`

May need to install `asciidoctor-kroki`, in directory root run:

`npm i asciidoctor-kroki`
