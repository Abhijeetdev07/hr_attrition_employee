# 📊 HR Employee Attrition & Analytics Dashboard

An end-to-end HR Analytics project that analyzes workforce data to identify key drivers of employee turnover, evaluate attrition patterns across departments and roles, and deliver actionable retention strategies using **Python**, **SQL**, and **Power BI**.

---

## 📌 Executive Summary & Key KPIs

| Metric | Value |
| :--- | :--- |
| **Total Employees** | **1,470** |
| **Total Attrition** | **237** |
| **Attrition Rate** | **16.12%** |
| **Average Monthly Income** | **$6,502.93** |
| **Average Employee Age** | **36.92 yrs** |

---

## 🖥️ Power BI Dashboard Showcase

### 1. Overview Dashboard
*High-level view of headcount, attrition rate, gender ratio, department breakdown, job roles, and experience groups.*

![Overview Dashboard](bi_assets/Screenshot%202026-10-04%20231106.png)

---

### 2. Demographics & Compensation Analysis
*Attrition rates segmented by education level, percentage salary hike, gender, age bracket, job level income distribution, and marital status.*

![Demographics and Compensation](bi_assets/Screenshot%202026-10-04%20231122.png)

---

### 3. Career, Tenure & Work Environment
*Impact of business travel frequency, years since last promotion, commute distance, overtime, total experience, and company tenure.*

![Career Tenure and Work Environment](bi_assets/Screenshot%202026-10-04%20231132.png)

---

### 4. Key Insights & Strategic Recommendations
*Executive findings highlighting high-risk employee segments and prioritized HR interventions.*

![Insights and Recommendations](bi_assets/Screenshot%202026-10-05%20184722.png)

---

## 🔍 Key Insights

1. **Overtime is the Primary Driver**: Employees working overtime leave at **30.53%** vs. **10.44%** for non-overtime staff. Overtime workers represent 54% of all exits.
2. **Early Tenure Flight Risk**: Highest turnover occurs within the first year (**36.36%** attrition rate for tenure < 1 yr).
3. **Role & Level Disparities**: **Sales Representatives** experience the highest role-based attrition (**39.76%**). Entry-level roles (Job Level 1, income < $3,000) account for 60% of leavers.
4. **Commute & Travel Stress**: Commute distance over 20 km (**22.06%**) and frequent business travel (**24.91%**) significantly elevate turnover rates.

---


## 🛠️ Project Architecture & Tech Stack

- **Data Cleaning & EDA**: [`hr_attrition.ipynb`](hr_attrition.ipynb) (Python, Pandas, Seaborn, Matplotlib)
- **Database & Business Queries**: [`hr_employee_attrition.sql`](hr_employee_attrition.sql) (MySQL data transformation & KPI extraction)
- **Business Intelligence**: [`HR ANALYTICS DASHBOARD.pbix`](HR%20ANALYTICS%20DASHBOARD.pbix) (Interactive 4-page Power BI Dashboard)
- **Executive Presentation**: [`HR_Attrition_Project.pptx`](HR_Attrition_Project.pptx) (Stakeholder summary deck)
