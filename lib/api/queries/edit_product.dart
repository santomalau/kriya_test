const editProduct = r'''
mutation editProduct($id: ID, $name: String, $lastName: String, $age : Int){
  editProduct(id:$id, name: $name, lastName: $lastName, age: $age) {
      id
      name
      lastName
      age
  }
}
''';
