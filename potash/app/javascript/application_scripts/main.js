window.addEventListener('DOMContentLoaded', (event) => {
  const analyzeButton = document.querySelector('#start-analysis');
  const loadingButton = document.querySelector('#started-analysis');
  console.log(analyzeButton)



  $("#new_image").submit(function() {
    analyzeButton.classList.add('d-none')
    loadingButton.classList.remove('d-none')
  })


  // for previewing the image that is attached
  function readURL(input) {
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = function(e) {
        $('#uploaded-image-preview').attr('src', e.target.result);
      }
      
      reader.readAsDataURL(input.files[0]); // convert to base64 string
    }
  }
  
  $("#uploaded-image").change(function() {
    readURL(this);
    const errorMessage = document.querySelector('#error-message');
    if (errorMessage) {
      errorMessage.classList.add('d-none')
    }
  });
});