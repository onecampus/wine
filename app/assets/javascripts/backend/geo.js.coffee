$(document).on 'ready page:load', ->
  if $('.manage-profile').length
    MultilevelSelect
      data: ADMINISTRATIVE_DIVISION
      nodes: [
        $('#s1')
        $('#s2')
        $('#s3')
      ]

  return
