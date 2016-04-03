User.create!([{
  name: 'John Doe',
  email: 'john@doe.com',
  username: 'johndoe',
  password: 'johndoe',
  level: User::ADMIN_LEVEL
}])