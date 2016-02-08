+++
date = "2016-02-06T08:02:50+01:00"
draft = false
title = "Angular Karma run tests images 404"
category = ["frontend"]
tags = ["angularjs", "karma"]

+++



When running Karma tests I've got some 404, errors: After digging on
stackoverflow, the solution is based on multiple misconfigured things:

- Add to file list, on karma config, a pattern for images, something like:

```
{
    patterh: path.join(conf.paths.src, '/assets/*/*.png'),
    watched: false,
    included: false,
    served: true    
}
```

With this, you tell the karma server, to serve found images.

- I still have some 404 errors, and seems that are paths not found. 
After much digging, I found the solution, proxying them with a 
**base** strange attribute:

```
proxies :{
    '/assets/images/': '/base/src/assets/images/'
}
```

After this, errors have gone.


