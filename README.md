# Sales-Data-Served-Three-Ways-SQL

Tools and Languages: Excel (associated SQL and Power BI projects coming soon)

Description and Intent: This analysis of electronics, appliances and accessories sales data from the USA, derived from twelve Kaggle CSV files spanning the entirety of 2019, was conducted to answer the files' associated series of questions (updated slightly to reflect different/additional queries):

What was the total sales amount for that year?

What was the best month for sales? How much was earned that month?

Which state had the highest total sales? How much?

Which city had the highest number of sales?

What time should we display advertisements to maximise the likelihood of customers buying products?

Which category of products is sold most often?

Which category of products generated the highest sales? How much?

Which product sold the most? Why do you think it sold the most?

The analysis was carried out entirely within Excel, including Power Query, with additional intentions to 'serve the data' with two additional options: SQL and Power BI.

Insights and Reporting: Following initial investigations to check consistency of structure across the twelve CSV files, they were loaded and combined via Power Query. The six fields included:

Order ID: The number system used to keep track of orders. Each order receives its own Order ID that will not be duplicated. This number can be useful to the seller when attempting to find out certain details about an order such as shipment date or status.

Product: The product that has been sold.

Quantity Ordered: The total item quantity ordered in the initial order (without any changes).

Price Each: The price of an individual product.

Order Date: The date the customer is requesting the order be shipped.

Purchase Address: Prepared by the buyer, often through a purchasing department. The purchase order, or PO, usually includes a PO number, which is useful in matching shipments with purchases; a shipping date; billing address; shipping address; and the request items, quantities and price.

Initial explorations of the fields and subsequent cleaning in Power Query involved manual checks on blank and null values; generic text entries for “Product”, “Order Date” and “Purchase Address” were identified (0.19% of total rows) and removed. Duplicated rows were also deleted (0.14% of total rows). Variable types were changed to appropriate text, numeric and date/time types. 

Additional columns were created to split the date/time entries into year, month, hour and minute, as well as to calculate the total sales value for each row. State and city were extracted into their own columns, and products were grouped according to category. Finally, the data was trimmed and cleaned.

Pivot tables were utilised to address each question specifically, with associated charts generated for use in dashboards. Three dashboard tabs were created to focus on sales and numbers related to time, product/category and location. The charts were linked to slicers that can impact all three boards to allow for considerations across all three breakdown categories.

Finally, the posed questions were answered as follows:

What was the total sales amount for that year? $34,465,538

What was the best month for sales? How much was earned that month? December, $4,608,296

Which state had the highest total sales? How much? California, $13,708,048

Which city had the highest number of sales? San Francisco, CA

What time should we display advertisements to maximise the likelihood of customers buying products? Two peaks were identified at 12pm and 7pm. Advertising around 9am-10am to coincide with mid-morning breaks, as well as around 5pm-6pm to coincide with post-work breaks, may reach the highest number of potential customers engaging in online shopping. 

Which category of products is sold most often? Batteries

Which category of products generated the highest sales? How much? Laptops, $12,160,459

Which product sold the most? Why do you think it sold the most? AAA batteries (4-pack), followed by AA batteries (4-pack), charging cables and headphones. These products are the cheapest in the list and are also known to run out or failure regularly.
