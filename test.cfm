<cfset NLDate = new NLDate() />

<cfoutput>

<ul>
	<li>
		<strong>Right Now: #f(Now())#</strong> 
	</li>
	<li>
		Today: #f(NLDate.parse('today'))# 
	</li>
	<li>
		Tomorrow: #f(NLDate.parse('tomorrow'))# 
	</li>
	<li>
		Yesterday: #f(NLDate.parse('yesterday'))#
	</li>
	<li>
		In an hour: #f(NLDate.parse('in an hour'))#
	</li>
	<li>
		In 2 days: #f(NLDate.parse('in 2 days'))#
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
		return dateFormat(arguments.Date,'long') & ' ' & timeFormat(arguments.Date,'long');
	}
</cfscript>