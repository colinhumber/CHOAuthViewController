## What is CHOAuthViewController?

CHOAuthViewController is a simple and easy way to authenticate and authorize OAuth 1.0(A) and OAuth 2 services. Authenticating is as simple as defining an OAuth service, creating and presenting the provided view controller, and registering for notifications when the user has completed authenticating and an OAuth access token is available. It wraps two mature OAuth projects for iOS and provides a simple UI, making implementing OAuth quick and easy. This is still very much a work in progress but it is being used in a number of personal apps. Any feedback is definitely welcome!

## How do I use it?

CHOAuthViewController includes an example project that details creating a service definition and authenticating against that service. It includes a number of sample OAuth service definitions, such as Facebook, Twitter, Instagram, etc.

First, clone the repository and initialize the submodules.
```
git submodule update --init
```

Next, you will need to copy over the contents of the CHOAuthViewController folder which contains the following classes:
- CHOAuthClient.h and .m   
- CHOAuthClientDelegate.h   
- CHOAuthServiceDefinition.h   
- CHOAuthViewController.h, .m, and .xib   
- Vendor classes ([LROAuth2Client](https://github.com/drekka/LROAuth2Client) and [OAuthConsumer](https://github.com/colinhumber/oauthconsumer))

Next, create your application on the desired service. Using the OAuth information provided by the service, create an object that conforms to the CHOAuthServiceDefinition protocol. The protocol defines all information required to authenticate against an OAuth 1.0(A) and OAuth 2 service, including all required authentication URLs, client key and secret, OAuth version, service name, and additional parameters required by the service. Check out some sample service definitions [here](https://github.com/colinhumber/CHOAuthViewController/tree/master/Example/CHOAuthViewController/Sample%20Service%20Definitions).

Next, register to receive a notification when the access token has been returned.   

```objective-c
- (void)viewDidLoad {
  [[NSNotificationCenter defaultCenter] addObserver:self 
										   selector:@selector(didReceiveAccessToken:) name:CHOAuthDidReceiveAccessTokenNotification object:nil];
}
```

Next, create an instance of CHOAuthViewController with an instance of your service definition and present the returned view controller.   

```objective-c
- (void)loginToInstagram {
	// CHInstagramDefinition is a class conforming to the CHOAuthServiceDefinition protocol
	CHInstagramDefinition *instagramDefinition = [[CHInstagramDefinition alloc] init];
	CHOAuthViewController *oAuthController = [[CHOAuthViewController alloc] initWithServiceDefinition:instagramDefinition];
	[self presentViewController:oAuthController animated:YES completion:nil];
}
```

Finally, if you notification callback, retrieve the appropriate OAuth 1.0(A) or OAuth 2 access token and dismiss the presented view controller. Depending on the OAuth version the service uses either an OToken or LROAuth2AccessToken instance will be returned in the object property of the NSNotification.

```objective-c
- (void)didReceiveAccessToken:(NSNotification *)note {
	id<CHOAuthServiceDefinition> serviceDefinition = [note.userInfo objectForKey:CHServiceDefinitionKey];
		
	if ([serviceDefinition oAuthVersion] == 1.0) {
		OToken *token = note.object;
	}
	else {
		LROAuth2AccessToken *token = note.object;
	}

	[self dismissViewControllerAnimated:YES completion:nil];
}
```

Each access token object conforms to the NSCoding protocol and can be archived to disk, saved in NSUserDefaults, saved to Keychain, etc.

## Requirements

CHOAuthViewController is ARC ready and requires iOS 5+.

If you are using CHOAuthViewController in an app that is not using ARC, you will need to set the ```-fobjc-arc``` compiler flag on all CHOAuthViewController source files, including the OAuthConsumer and LROAuth2Client classes. This can be done by going to the desired target, selecting Build Phases, and expanding the Compile Sources step. Select all CHOAuthViewController, OAuthConsumer, and LROAuth2Client classes, press Enter, and insert ```-fobjc-arc``` in the popup, and click 'Done'.

## To do

- abstract the type of token returned from the service into a single token class

## Credits

CHOAuthViewController uses projects by Jon Crosby [(OAuthConsumer)](https://github.com/colinhumber/oauthconsumer) (modified to use ARC) and Luke Redpath [(LROAuth2Client)](https://github.com/drekka/LROAuth2Client) (modified to allow for custom OAuth 2 token responses) for handling the internals of authenticating against OAuth services. 

## License

CHOAuthViewController is available under the MIT license. See the LICENSE file for more info.