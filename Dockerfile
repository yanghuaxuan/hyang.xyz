FROM klakegg/hugo

WORKDIR /src

COPY ./ /src

ENTRYPOINT hugo serve 
