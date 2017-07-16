# [CMR CATALOGUE SERVICE FOR THE WEB (CSW)](https://cmr.earthdata.nasa.gov/csw)

Visit NASA's CSW based on the EOSDIS COMMON METADATA REPOSITORY (CMR) at
[https://cmr.earthdata.nasa.gov/csw](https://cmr.earthdata.nasa.gov/csw)

## About
The CMR CSW is a web application developed by [NASA](http://nasa.gov) [EOSDIS](https://earthdata.nasa.gov)
to enable data discovery, search, and access across EOSDIS' Earth Science data holdings.
It provides an interface compliant with the [OpenGIS Catalogue Service Implementation Specification v 2.0.2](http://portal.opengeospatial.org/files/?artifact_id=20555)
by taking advantage of NASA's [Common Metadata Repository (CMR)](https://cmr.earthdata.nasa.gov/search/) APIs for data discovery and access.

## License

> Copyright © 2007-2014 United States Government as represented by the Administrator of the National Aeronautics and Space Administration. All Rights Reserved.
>
> Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
> You may obtain a copy of the License at
>
>    http://www.apache.org/licenses/LICENSE-2.0
>
> Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
> WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Third-Party Licenses

See public/licenses.txt

## Installation

* Ruby 2.1.2
* A Ruby version manager such as [RVM](http://rvm.io/) or [rbenv](https://github.com/rbenv/rbenv) is strongly recommended.

### Initial setup
Once the repository is cloned locally and Ruby 2.1.2 is installed, you must install the dependencies.
If you don't have the [bundler](http://bundler.io/) gem already installed, execute the command below in the project root directory:
   
    gem install bundler   

or if you wish to install the bundler without documentation:

    gem install bundler --no-rdoc --no-ri

Install all the gem dependencies:

    bundle install    

### Set up the required environment
The application requires the environment variables below to be set.

String that uniquely identifies your specific CMR CSW installation:
    
    client_id = <your client identifier>
    
### Run the automated [Rspec](http://rspec.info/) tests
Execute the command below in the project root directory:

    bin/rspec

All tests should pass.

### Run the application
Execute the command below in the project root directory:

    rails server

Open `http://localhost:3000/csw` in a local browser.
