# Sales-Data-Served-Three-Ways-SQL

Tools and Languages: SQL (see associated Excel and Power BI (coming soon) projects)

Description and Intent: This analysis of electronics, appliances and accessories sales data from the USA, derived from twelve Kaggle CSV files spanning the entirety of 2019, was conducted to answer the files' associated series of questions (updated slightly to reflect different/additional queries):

What was the total sales amount for that year?

What was the best month for sales? How much was earned that month?

Which state had the highest total sales? How much?

Which city had the highest number of sales?

What time should we display advertisements to maximise the likelihood of customers buying products?

Which category of products is sold most often?

Which category of products generated the highest sales? How much?

Which product sold the most? Why do you think it sold the most?

The analysis was carried out entirely within SQL (Microsoft SQL Server), with additional intentions to 'serve the data' with two additional options: Excel and Power BI.

Insights and Reporting: This analysis had been conducted previously in Excel, so there was some prior understanding of the data, as well as the option to cross-check calculated values. The six associated fields included:

Order ID: The number system used to keep track of orders. Each order receives its own Order ID that will not be duplicated. This number can be useful to the seller when attempting to find out certain details about an order such as shipment date or status.

Product: The product that has been sold.

Quantity Ordered: The total item quantity ordered in the initial order (without any changes).

Price Each: The price of an individual product.

Order Date: The date the customer is requesting the order be shipped.

Purchase Address: Prepared by the buyer, often through a purchasing department. The purchase order, or PO, usually includes a PO number, which is useful in matching shipments with purchases; a shipping date; billing address; shipping address; and the request items, quantities and price.

The 12 CSV files were combined via the 'Union' function into a new single table with duplicates removed. The resulting data was explored in general and two rows with blank and generic “Product”, “Order Date” and “Purchase Address” values, as well as 34 rows with dates outside of 2019, were removed. Some column types were converted from 'varchar' to numeric types to enable desired aggregations. At this stage, and for much of the subsequent stages, the data and calculated values mirrored that of the Excel analysis. 

In addition to the 'Union' joins, a variety of aggregations were used, as was extraction of datetime components from 'varchar' date strings and substring extractions of locations from 'varchar' address values. CTEs, Subqueries and Case Statements were used at various points.

Despite the initial calculated values matching exactly those in the associated Excel analysis, very slight differences emerged (as small as 0.0003%) in the later explorations of categories and products. This prompted me to re-examine the Excel data and the discovery of minor inaccuracies in its analysis highlighted very clearly the value of examining data from multiple angles, particularly in the absence of other assisting analysts. As the three-tier approach of analysing this data using Excel, SQL and Power BI was focused on the overall differences in process, this analysis as outlined is presented here while I further consider the minor variations in values. 

Finally, the posed questions were answered as follows:

What was the total sales amount for that year? $34,456,868

What was the best month for sales? How much was earned that month? December, $4,608,296

Which state had the highest total sales? How much? California, $13,699,563

Which city had the highest number of sales? San Francisco, CA

What time should we display advertisements to maximise the likelihood of customers buying products? Two peaks were identified at 12pm and 7pm. Advertising around 9am-10am to coincide with mid-morning breaks, as well as around 5pm-6pm to coincide with post-work breaks, may reach the highest number of potential customers engaging in online shopping. 

Which category of products is sold most often? Batteries

Which category of products generated the highest sales? How much? Laptops, $12,156,800

Which product sold the most? Why do you think it sold the most? AAA batteries (4-pack), followed by AA batteries (4-pack), charging cables and headphones. These products are the cheapest in the list and are also known to run out or failure regularly.
