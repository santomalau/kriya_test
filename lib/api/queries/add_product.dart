const addProduct = r'''
mutation addProduct($id: ID, $name: String, $lastName: String, $age : Int){
  addProduct(id:$id, name: $name, lastName: $lastName, age: $age) {
      id
      name
      lastName
      age
  }
}
''';
