# Diverst Analytics 

Describes the Analytics service

The Analytics module consists of several interworking components:

- AWS Lambda Application    - computes the graphs & uploads results into S3
- Backend Application       - retrieves metric data from S3 & serves it to clients
- Frontend Application      - retrieves data from backend, displays graphs & performs filtering operations

## Analytics module concepts & structure

Currently, there are two separate types of analytics Diverst offers:

- Static metrics
- Custom metrics

##### Static metrics

Static metrics are predefined metrics that don't change with user input, apart from filtering operations the user might invoke.

Our static metrics are defined as SQL queries inside the Lambda analytics function. As described further down, these metrics are then uploaded to S3 & served by our backend.

##### Custom metrics

Custom metrics are aggregation queries we perform on the _custom fields_ associated specifically with the user. For information specifically regarding custom fields see the fields documentation.

Under _Custom Metrics_ a user can create a _metrics dashboard_ which consists of a list of graphs. Inside a _metrics dashboard_, users submit a form allowing them to create _custom graphs_. _Custom graphs_ consist of at least one _field_ & optionally, a second _aggregation field_.

Custom graphs are stored in the database under the `graph` table. The graph table has `field` & `agggregation_field` columns. These fields are stored as numeric ids identifying a _custom field_ in the `field` table. 

At the time of this writing, all _custom graphs_ are presented as _bar graphs_. If an _aggregation field_ is chosen, then the graphs are presented as _stacked bar graphs_. 

!!!! _TODO: describe lambda & custom metrics_ !!!!

Custom metrics are defined in the database by the user, the queries are performed alongside the static metrics with AWS Lambda. 

!!!! _TODO: describe lambda & custom metric creation_ !!!!

Because users expect a near realtime response when _creating_ a new graph, we must also define an additional lambda function to respond to _custom graph creation_ events & perform the queries on user request.


## AWS Lambda

Analytics are computed with an AWS Lambda function that runs on a scheduled CloudWatch Alarm.

The Lambda function consists of a list SQL queries for each metric. the function runs all the queries & then uploads each SQL result as JSON into a S3 object.

!!!! _TODO: details for custom metrics_ !!!!

## Backend Application

The backend's role is to expose endpoints per metric & serve the JSON data from S3.

All of the analytics endpoints are the root path `/analyze`

_Note: In the future, we will be migrating towards offering a separate 'Analytics API' service, with AWS API Gateway._

#### Backend structure

The backend defines a `Graph` model/table. `Graph` defines `field` & an optional `aggregation` that define how custom graphs are calculated. The model itself consists of any necessary logic related to creating these graphs.

Associated to the `Graph` model is a Rails `metrics` concern that handles the logic of connecting to S3 and pulling out the metrics.

For static metrics, inside the `metrics` concern, we define a series of small static functions for each static metric we expose. These fuctions read & return the JSON data from the S3 object for that metric. This allows us to write code like the following:

```
Graph.group_population
Graph.user_growth_percentage
```

## Frontend Application

The frontend applications role is to retrieve & visually present the metrics data from the backend. We achieve this mainly with the use of _VegaLite_. _VegaLite_ is a grammar or DSL of interactive graphics, written in JSON _schemas_. 

Additionally, the frontend allows the user to filter the data they are viewing by providing several types of filtering tools, ie by _group_ or date.

#### Frontend structure

##### Overview

The frontend metrics/analytics code is generally split up into _dashboards_ & _graphs_.
 
 Dashboards display a list of graphs & metrics and optionally provide filtering mechanisms that allow the user to narrow down the data they are viewing in the entire dashboard. The _dashboard containers_ are responsible for any logic around filtering or any other kind of custom functionality specific to that dashboard, the _dashboard components_ are responsible for rendering the graphs & other data that should be displayed on that dashboard.
 
 Graphs are responsible for visually displaying a set of data. Generally, the graphs should be/are stand alone so that they could in theory be imported into any place in the app that might want to display them. Like the dashboards, the graphs may provide there own graph specific filtering tools, such as clickable legends or date range selection. As an abstraction & reuse of code, we define the _base graphs_, ie line graph, bar graph separately under `BaseGraphs` as components. These components are where we define the VegaLite schema's that define how our graphs look & behave. All our graphs are based off of these. 


##### Data structure 

The data structure produced by MYSQL & accepted by VegaLite is a flat array of objects. The array is known as a _data set_ or just _data_. An object in this array is called a _data point_.

The keys in the data points used by VegaLite, depend on the type of base graph & the correlate to VegaLite _field types_. The current base VegaLite graphs make use of three types & thus expect the data point keys to be named as follows:

- _Nominal_: `name`
- _Quantitative_: `count`
- _Temporal_: `date`

##### Labels 

_!! Implementation is WIP !!_

The base VegaLite graphs accept a prop `labels` for setting the title & axis labels. The prop `labels` should be formatted as follows:

```
{
  title: <title>,
  x_label: <x_label>,
  y_label: <y_label>
}
```


##### Filtering 

To be as flexible as possible, we define a very generic filtering functionality. All graphs accept a list of data & a list of _filter objects_. If the graph provides its own specific filter mechanisms as described above, then it will also add its own _filter objects_ into this _filter object list_. Before rendering, the graph passes its data & its list of filter objects through a _filter function_. 

In our `metricsHelpers` we define a function `filterData`. This function accepts a list of data & a list of _filter objects_. Filter objects are defined as follows

```
   *   A `filter object` describes a `filter operation` to be carried out on a data point in order to determine whether
   *   it should be included in the filter data set
   *
   *   A filter object must be written as follows: { key: <>, value: <>, op: <> }
   *     `key`:   The key inside each data point in the data set, containing the value to be compared
   *     `value`: The literal value to be compared against `key` in each data point
   *     `op`:    The comparison operator to be applied, must be one of the following:
   *              '==', '!=', '>', '>=', '<=', '<', '<=', 'in'
   *
   *   - Filter operations will always be carried out as: `datapoint.key <op> value`
   *   - Each filter object will be applied against the data point, all must be true in order for the data point to be included.
   *   - The `in` operator expects `value` to be an array of literal values, runs <value-array>.includes(datapoint.key)
```

The filter function will then apply each filter object to each data point. Because the graphs all accept a list of filter objects, they become extremely customizable, allowing the dashboards that render them to apply complex, custom filtering logic to whatever extent necessary. 

