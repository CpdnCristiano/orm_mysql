# API example
This was a test API, it was returned using [get_server](https://pub.dev/packages/get_server) as a backend server and [ORM_Mysql](https://github.com/CpdnCristiano/orm_mysql).


### Testing

##### Create
to start making a request on the `https://orm-get-server.herokuapp.com/api/user` link with the post method and with the json body in this format.

```json
{	
    "name": "YOUR_NAME",
    "age": 0, 
    "email": "YOUR_EMAIL",
    "isActive": true
}
```
The request response will be as in the photo
![Create_user_response](https://user-images.githubusercontent.com/54460776/93423711-f5baee80-f88c-11ea-8a15-05905a62ea43.png)

##### Read
make a new request on `https://orm-get-server.herokuapp.com/api/user` using the get method, it will return all users, you can also search for the user id, make a new request on `https://orm-get-server.herokuapp.com/api/user?id=1`

##### Update
Make a new request request using the put method on the `https://orm-get-server.herokuapp.com/api/user?id=1` by passing the user ID as a parameter, and with the json body, as the create request.

##### Delete

Make a new request request using the delete method on the  `https://orm-get-server.herokuapp.com/api/user?id=1`, passing the user ID as a parameter

</br>
observations: In the future, the ORM will have a relationship between the wait
