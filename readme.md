#Nanotwitter

To run the application, run ruby.rb, then request 0:0:0:0/4567 <br>
you could sign up and then sign in to post a twitter, follow and unfollow.<br>
or just use our test user:<br>
username: user0 <br>
password: 1234<br>


Remember to log out!


##loader.io(250 requests per minute)

no index:<br><br>
make 12 users<br>
Average	673 ms<br>
Min/Max	116 / 3250 ms<br><br>

make 12 tweets<br>
Average	53 ms<br>
Min/Max	15 / 215 ms<br><br>

make 12 follow<br>
Average	561 ms<br>
Min/Max	141 / 2081 ms<br><br><br>

with index<br><br>

make 12 users<br>
Average	86 ms<br>
Min/Max	55 / 165 ms<br><br>

make 12 tweets<br>
Average	120 ms<br>
Min/Max	54 / 510 ms<br><br>

make follow 12<br>
Average	159 ms<br>
Min/Max	57 / 520 ms<br><br>

With index, making 12 users is becoming quicker, since time spent to check if such user exist is improved(since there is a unique name constraint). making tweets is becomming slower, because for every tweet inserting, we also have to to the indexing. Follow relationship is become quicker, also because indexing improve the speed of searching.