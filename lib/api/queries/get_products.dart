// const getProduct = r'''
//   query GetJobs() {
//     jobs {
//       id,
//       title,
//       locationNames,
//       isFeatured
//     }
//   }
// ''';
const getProduct = r"""
  query {
      products{
        id, 
        name, 
        lastName, 
        age}
  }
""";
