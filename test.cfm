<cfset NLDate = new NLDate() />

<cfoutput>

<ul>
	<li>
		<strong>Today: #f(NLDate.parse('today'))#</strong> 
	</li>
	<li>
		Yesterday: #f(NLDate.parse('yesterday'))#
	</li>
	<li>
		Last Week: #f(NLDate.parse('last week'))#
	</li>
	<li>
		Two Weeks Ago: #f(NLDate.parse('two weeks ago'))#
	</li>
	<li>
		Last Month: #f(NLDate.parse('last month'))#
	</li>
	<li>
		A Couple Days Ago: #f(NLDate.parse('a couple days ago'))#
	</li>
	<li>
		A Few Months Ago: #f(NLDate.parse('a few months ago'))#
	</li>
	<li>
		Last Mar: #f(NLDate.parse('last mar'))#
	</li>
	<li>
		Last March: #f(NLDate.parse('last march'))#
	</li>
</ul>
	
</cfoutput>
<cfscript>
	public string function f(Required Date Date) {
		return dateFormat(arguments.Date,'long');
	}
</cfscript>