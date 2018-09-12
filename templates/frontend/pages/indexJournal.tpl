{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 * @uses $issue Issue Current issue
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

{**
{if $homepageImage}
	<div class="homepage-image{if $issue} homepage-image-behind-issue{/if}">
		<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" alt="{$homepageImageAltText|escape}">
	</div>
{/if}
**}
<div class="container container-homepage-issue">
	{**
	<div class="container about-journal" role="complementary" aria-label="{translate|escape key="common.navigation.sidebar"}">
    	{call_hook name="Templates::Common::Sidebar"}
	</div>
	**}
	{* Additional Homepage Content *}
	{**
	{if $additionalHomeContent}
	<div class="row justify-content-center homepage-additional-content">
		<div class="col-lg-9">{$additionalHomeContent}</div>
	</div>
	{/if}
	**}

	{if $journalDescription}
	<div class="journal-description">
		{$journalDescription}
	</div>
	{/if}

	{* Announcements *}
	{if $numAnnouncementsHomepage && $announcements|count}
	<section class="cmp_announcements media">
		<div class="media-list">
			<header class="page-header">
				<h2>
					{translate key="announcement.announcements"}
				</h2>
			</header>

			{foreach name=announcements from=$announcements item=announcement}
				{if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
					{php}break;{/php}
				{/if}
				{include file="frontend/objects/announcement_summary.tpl" heading="h3"}
			{/foreach}
		</div>
	</section>
    {/if}

{if $issue}
		<h2 class="h5 homepage-issue-current">
			{translate key="journal.currentIssue"}
		</h2>
		<div class="h1 homepage-issue-identifier">
			{$issue->getIssueSeries()}
		</div>
		<div class="h6 homepage-issue-published">
			{translate key="plugins.themes.healthSciences.currentIssuePublished" date=$issue->getDatePublished()|date_format:$dateFormatLong}
		</div>

		{* make the entire block conditional if there aren't any additional issue data *}
		{if  $issue->getLocalizedCoverImageUrl() || $issue->hasDescription() || $issueGalleys}
			<div class="row justify-content-center homepage-issue-header">
				{if $issue->getLocalizedCoverImageUrl()}
					<div class="col-lg-3">
						<a href="{url op="view" page="issue" path=$issue->getBestIssueId()}">
							<img class="img-fluid homepage-issue-cover" src="{$issue->getLocalizedCoverImageUrl()|escape}"{if $issue->getLocalizedCoverImageAltText() != ''} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
						</a>
					</div>
				{/if}
				{if $issue->hasDescription() || $issueGalleys}
					<div class="col-lg-9">
						<div class="homepage-issue-description-wrapper">
							{if $issue->hasDescription()}
								<div class="homepage-issue-description">
									<div class="h2">
										{if $issue->getLocalizedTitle()}
											{$issue->getLocalizedTitle()}
										{else}
											{translate key="plugins.themes.healthSciences.issueDescription"}
										{/if}
									</div>
									{$issue->getLocalizedDescription()|strip_unsafe_html}
									<div class="homepage-issue-description-more">
										<a href="{url op="view" page="issue" path=$issue->getBestIssueId()}">{translate key="common.more"}</a>
									</div>
								</div>
							{/if}
							{if $issueGalleys}
								<div class="homepage-issue-galleys">
									<div class="h3">
										{translate key="issue.fullIssue"}
									</div>
									{foreach from=$issueGalleys item=galley}
										{include file="frontend/objects/galley_link.tpl" parent=$issue purchaseFee=$currentJournal->getSetting('purchaseIssueFee') purchaseCurrency=$currentJournal->getSetting('currency')}
									{/foreach}
								</div>
							{/if}
						</div>
					</div>
				{/if}
			</div>
		{/if}

		<div class="row justify-content-center{if $homepageImage && $issue->hasDescription()} issue-full-data{elseif $homepageImage && $issue->getLocalizedCoverImageUrl()} issue-image-cover{elseif $homepageImage} issue-only-image{/if}">
			<div class="col-12 col-lg-9">
				{include file="frontend/objects/issue_toc.tpl" sectionHeading="h3"}
			</div>
		</div>

		<div class="text-center">
			<a class="btn" href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}">
				{translate key="journal.viewAllIssues"}
			</a>
		</div>
	{/if}

<!--	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<div class="row justify-content-center homepage-additional-content">
			<div class="col-lg-9">{$additionalHomeContent}</div>
		</div>
	{/if}-->
</div><!-- .container -->

{include file="frontend/components/footer.tpl"}