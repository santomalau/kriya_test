const deleteProduct = r'''
mutation deleteProduct($id: ID!){
  deleteProduct(id:$id) {
      id
  }
}
''';
