# METEOR-VERSION 1.2.1
FROM phusion/passenger-nodejs:0.9.18
MAINTAINER Haydn (https://github.com/Grepgames/docker-meteor-passenger)

RUN apt-get update && \
    apt-get install -y -o Dpkg::Options::="--force-confold" passenger nginx-extras && \
    apt-get -y upgrade

# Install git, curl, python, and phantomjs
RUN apt-get install -y git curl python phantomjs

# Make sure we have a directory for the application
RUN mkdir -p /var/www
RUN chown -R www-data:www-data /var/www

# Enable nginx
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

# Install fibers -- this doesn't seem to do any good, for some reason
RUN npm install -g fibers

# Install Meteor
RUN curl https://install.meteor.com/ |sh

# Install entrypoint
ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Add known_hosts file
ADD known_hosts /root/.ssh/known_hosts

EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD []

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
