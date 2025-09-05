# Boston 311 Calls Project

Demand for Boston 311 non-emergency services **grew by 35% from 2015 to 2024,** despite the fact that the city’s population declined slightly over that same time period. In 2024 alone, the city logged nearly 283,000 requests -- about 773 per day. **This project uses SQL and Tableau to explore the drivers behind that growth**, focusing on changes in request types, department workloads, neighborhood patterns, and case resolution times. 

The full Tableau dashboard can be found [here](https://public.tableau.com/views/Boston311CallsDashboardVersion4/Borders4?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link). 

<img width="400" alt="Image" src="https://github.com/user-attachments/assets/e395fca1-fbc3-48ed-93af-2a0e1dd7a92b" />

---

## Findings
311 requests have grown substantially, up 35% since 2015.

#### What types of requests are driving growth?
1. The single biggest increase came from **Enforcement & Abandoned Vehicles**, which rose from 11,000 requests in 2015 to around 68,000 in 2024 -- representing about 46% of all growth in the 311 system. Nearly all of this increase was from parking enforcement (+55,000). Unsurprisingly, the Transportation Department, the main entity that handles these requests, saw its overall caseload of transportation issues increase by 230% over the last decade, from around 25,000 to 82,000.

2. The second big driver of the increase was **Code Enforcement,** which had 36,000 more cases in 2024 compared to 2015 (a 98% increase). This includes issues like trash barrels left out improperly (+20,000), poor property conditions (+8,600), unshoveled sidewalks (+3,800), and illegal dumping (+3,000). Code enforcement falls under the Public Works department. While Public Works has always been the busiest department, its mix has shifted away from sanitation and toward code complaints.

3. The third largest driver is the **Needle Program**, which grew from only ~600 calls in 2015 to over 10,000 in 2024, due to needle pickup requests.

Notes: It's possible some growth may stem from changes in how requests are categorized (further research is needed to assess this). Additionally, not every category increased: sanitation declined from 34,700 → 10,800, building issues from 12,200 → 5,000, and highway maintenance from 27,600 → 22,600. Even within categories that are on the rise, certain sub-categories have declined.

#### Which zip codes are driving growth?

Among zip codes with at least 5 requests in 2015, those with the largest % increase over the last decade were 02210 (in Seaport) 02118 (in the South End), and 02127 (in South Boston):

<img width="400" alt="Image" src="https://github.com/user-attachments/assets/96b264d6-35d1-4d79-afd0-c6d029238696" />

<sub>(Visit full [dashboard](https://public.tableau.com/views/Boston311CallsDashboardVersion4/Borders4?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) for interactive version.)</sub>

#### How quickly are cases closed?

Boston appears to be getting faster at closing out cases. In 2015, the median time to close was two days and nine hours. One year later, in 2016, it was 17 hours. In 2024, the median was just 10 hours.  

That said, the overall progress citywide masks big differences between departments. Public Works had a median closure time in 2024 of just **4 hours**, while the Transportation Department -- the fastest-growing source of requests -- has a median closure time of **24 hours**.

<img width="400" alt="Image" src="https://github.com/user-attachments/assets/e65d5757-bb71-49fd-b904-c4656de13ed6" />

<sub>(Visit full [dashboard](https://public.tableau.com/views/Boston311CallsDashboardVersion4/Borders4?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) for interactive version.)</sub>


---

## Technical Approach
### Datasets
- Analyze Boston, [311 Service Requests (2015–2024)](https://data.boston.gov/dataset/311-service-requests). The data is published as ten separate annual datasets (one for each year).
- City Population Data: American Community Survey 1-year estimates. For 2024, 2023 estimates were used.
- Zip Code Population Data: American Community Survey 5-year estimates. For 2024, 2023 estimates were used.
### SQL Files
- schema.sql – defines the database tables
- load_data.sql – instructions for loading and staging yearly CSVs
- analysis.sql – SQL queries used to generate the findings below
### Approach
- Built PostgreSQL database with three main tables: service requests (2.6M records consolidated from 10 annual spreadsheets into a single table spanning 2015 to 2024), citywide population (2015 - 2024), and zip-level population data (2015 - 2024)
- Wrote SQL queries to analyze trends in requests across time, departments, request types, and geography
- Used window functions for ranking departments and reasons by year
- Created pivot tables to compare top categories across years
- Joined service request data with population data for per-population analysis
- Built interactive Tableau dashboard with filtering capabilities, geographic mapping, and time-series visualizations to make findings accessible to non-technical audiences
