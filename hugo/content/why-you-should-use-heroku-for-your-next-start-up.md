+++
title = "Why you should use Heroku for your next start-up"
author = ["Honza Pokorny"]
date = 2012-05-21T16:43:00-03:00
categories = ["devops"]
draft = false
+++

You are a ninja-rockstar developer with a billion dollar idea. You write Ruby
and Javascript. You like BDD, responsive design, HTML5 and node.js. You are
really good at UX and quickly producing a prototype. You have been working on
your app for a few months.

Now it's time to deploy your app.

Because you are a hot new start-up, you will of course use AWS. You spend a
few hours trying to figure out how many of which instance type you will need.
You decide you need a load balancer, a bunch of app servers, a database server
and a worker server. That should about cover you. Next up is Chef. You spend
a few days learning about provisioning a new VM with Chef. You are so excited
about how you can automatically provision a new app server when your start-up
hits the front page of TechCrunch. You spend a week configuring and testing
your Chef scripts. And then the big day comes. You deploy your application.
Everything works the first time and you are overjoyed. First users start to
appear and your architecture performs really well. You hit the front page of
HackerNews and get tens of thousands of hits on your site. You find a small
bug in your cache invalidation logic which you fix really quickly. You deploy
your fix and what do you know? That script that installs your project's
dependencies when you deploy just pulled in a new version of a library that
deploys your static files to S3. And of course that new version contains
backwards incompatible changes and completely breaks your app. You are
frantically trying to figure out what happened. You think, OK, I will put up a
maintenance page while I sort this out. You try to SSH into your load balancer
and try to change the routing settings. What a mess. What do you do when your
database starts swapping? What happens when your Redis server runs out of
memory and dies? You barely understand how to install MySQL, let alone how to
get the most out of it.

Enter Heroku.

Single command deployments. Fully-managed database service. Automatic
load-balancing. On-demand scaling. No manual SSH to see what's wrong.

A request comes in, the load balancer picks it up and sends it to a suitable
app server instance. The app server instance talks to a highly optimized
database instance. Redis is sitting on a super beefy machine with lots of RAM
and you never have to worry about it. When you are ready to make a deployment,
the load balancer bounces each app server in turn to make sure you don't lose
any requests. All you need to do is `git push heroku master`.

Sure, Heroku is a bit more expensive than EC2. But when you think of how many
smart people are taking care of your app, it's really cheap. It's like having
your own sys admin.

You need it.

<strong>Disclaimer</strong>: I'm in no way connected to Heroku. This posts is an attempt to
convince myself that I shouldn't be using Chef for my
side-project-start-up-ideas. And I'm not a Ruby guy.
