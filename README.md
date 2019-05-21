# developer-environment
A self-contained environment for Java and Ruby development.
Includes (not-exhaustive):
- openjdk 8
- AWS cli
- hub

## Running
To run the latest release, just clone the repo and execute the included script
```
git clone https://github.com/edwardmlyte/developer-environment.git
cd developer-environment
./dev-env
```

## Development
To build it locally run something along the lines of:
```
docker build . -t dev-env:local
```
That'll push it to your local Docker store tagged as `dev-env:local`. Then replace the released tag `edwardmlyte/developer-environment:latest` with the new tag and run the `dev-env` script again.
