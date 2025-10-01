# Set up environment
environment:
	npm ci

# Build Product or Community
local-product:
	mkdir -p tmp
	bin/switch-prod-comm product
	npx antora --version
	npx antora --stacktrace --log-format=pretty --log-level=info \
		turtles-local-product-playbook.yml \
		2>&1 | tee tmp/local-product-build.log 2>&1

local-community:
	mkdir -p tmp
	bin/switch-prod-comm community
	npx antora --version
	npx antora --stacktrace --log-format=pretty --log-level=info \
		turtles-local-community-playbook.yml \
		2>&1 | tee tmp/local-community-build.log 2>&1

remote-product:
	mkdir -p tmp
	npm ci
	bin/switch-prod-comm product
	npx antora --version
	npx antora --stacktrace --log-format=pretty \
		turtles-remote-product-playbook.yml \
		2>&1 | tee tmp/remote-product-build.log 2>&1

remote-community:
	mkdir -p tmp
	npm ci
	bin/switch-prod-comm community
	npx antora --version
	npx antora --stacktrace --log-format=pretty \
		turtles-remote-community-playbook.yml \
		2>&1 | tee tmp/remote-community-build.log 2>&1

#Dev builds using the 'next' folder
dev-product:
	mkdir -p tmp
	bin/switch-prod-comm product
	npx antora --version
	npx antora --stacktrace --log-format=pretty --log-level=info \
		turtles-dev-product-playbook.yml \
		2>&1 | tee tmp/dev-product-build.log 2>&1

dev-community:
	mkdir -p tmp
	bin/switch-prod-comm community
	npx antora --version
	npx antora --stacktrace --log-format=pretty --log-level=info \
		turtles-dev-community-playbook.yml \
		2>&1 | tee tmp/dev-community-build.log 2>&1

# Clean build output
clean:
	rm -rf build

# Preview Community and/or Product build output
preview-product: ## Preview the site locally with http-server.
	npx http-server build/site-product -c-1 -p 8080

preview-community: ## Preview the site locally with http-server.
	npx http-server build/site-community -c-1 -p 8081

preview-dev-product: ## Preview the site locally with http-server.
	npx http-server build/site-dev-product -c-1 -p 8080

preview-dev-community: ## Preview the site locally with http-server.
	npx http-server build/site-dev-community -c-1 -p 8081