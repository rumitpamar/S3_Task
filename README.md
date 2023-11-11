# S3_Task


 ###################################################################################################################################################################################################

  # Adding here the steps where object which is not accesible for more than 1 year out of S3 will be store into the "DEEP_ARCHIVE" tier for more cost optimization
  # Also this block is by defaulted commented here by me it'll will be uncommented if this block is require

  ###################################################################################################################################################################################################    

  # tiering {
  #   days        = 360
  #   access_tier = "DEEP_ARCHIVE"
  # }




##############  CloudFront Block  ##############

#This block is by default uncommented; however, the Cloudfront block will be helpful if the data is accessible globally.
# With CloudFront, our costs will decrease as the speed of data delivery increases.
# Our expenses will go down with CloudFront as the speed at which data is delivered rises. However, as cloudfront stores data at many edge locations, it will cost us if the data is not globally available or if it is region-specific. 


# these must be uncommented based on specific rquirments. Here I use all edge location but if the access is not globally then we can comment this line and uncomment below one

  price_class = "PriceClass_100" # Use all edge locations (best performance)
  # price_class = "PriceClass_200" # Use only North America and Europe

  # Distribution settings
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # Uncomment one of the following lines based on requirments
      # locations         = ["US", "CA", "EU"]
      # locations         = ["US", "CA", "EU", "AS", "ME", "AF"]
    }
  }
