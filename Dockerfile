FROM dannyben/alpine-ruby

ENV PS1 "\n\n>> completely \W \$ "
WORKDIR /app

RUN gem install completely --version 0.6.2

ENTRYPOINT ["completely"]