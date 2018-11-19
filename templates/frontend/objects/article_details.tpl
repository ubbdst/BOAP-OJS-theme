{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Core components are produced manually below. Additional components can added
 * via plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $copyright string Copyright notice. Only assigned if statement should
 *   be included with published articles.
 * @uses $copyrightHolder string Name of copyright holder
 * @uses $copyrightYear string Year of copyright
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}
<div class="article-details">
	<div class="page-header row">
		<div class="col-lg article-meta-mobile">
			{* Title and issue details *}
			<div class="article-details-issue-section small-screen">
				<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{$issue->getIssueSeries()}</a>{if $section}, <span>{$section->getLocalizedTitle()|escape}</span>{/if}
			</div>

			<div class="article-details-issue-identifier large-screen">
				<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{$issue->getIssueSeries()}</a>
			</div>

			{if $section}
				<div class="article-details-issue-section large-screen">{$section->getLocalizedTitle()|escape}</div>
			{/if}

			<h1 class="article-details-fulltitle">
				{$article->getLocalizedFullTitle()|escape}
			</h1>

			{if $article->getAuthors()}
				<ul class="authors-string">
					{foreach from=$article->getAuthors() item=authorString key=authorStringKey}
						{strip}
							<li>
								<a class="author-string-href" href="#author-{$authorStringKey+1}">
									<span>{$authorString->getFullName()|escape}</span>
									<sup class="author-symbol author-plus">&plus;</sup>
									<sup class="author-symbol author-minus hide">&minus;</sup>
								</a>
								{if $authorString->getOrcid()}
									<a class="orcidImage" href="{$authorString->getOrcid()|escape}"><img src="{$baseUrl}/{$orcidImage}"></a>
								{/if}
							</li>
						{/strip}
					{/foreach}
				</ul>

				{* Authors *}
				{assign var="authorCount" value=$article->getAuthors()|@count}
				{assign var="authorBioIndex" value=0}
				<div class="article-details-authors">
					{foreach from=$article->getAuthors() item=author key=authorKey}
						<div class="article-details-author hideAuthor" id="author-{$authorKey+1}">
							<div class="article-details-author-name small-screen">
								{$author->getFullName()|escape}
							</div>
							{if $author->getLocalizedAffiliation()}
								<div class="article-details-author-affiliation">{$author->getLocalizedAffiliation()|escape}</div>
							{/if}
							{if $author->getOrcid()}
								<div class="article-details-author-orcid">
									<a href="{$author->getOrcid()|escape}" target="_blank">
										{$orcidIcon}
										{$author->getOrcid()|escape}
									</a>
								</div>
							{/if}
							{if $author->getLocalizedBiography()}
								<div class="article-details-author-bio">{$author->getLocalizedBiography()}</div>
							{/if}
						</div>
					{/foreach}
				</div>

			{/if}
			{* DOI only for large screens *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{php}continue;{/php}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<div class="article-details-doi large-screen">
						<a href="{$doiUrl}">{$doiUrl}</a>
					</div>
				{/if}
			{/foreach}

			{* Date published *}
			{if $article->getDatePublished()}
				<div class="article-details-published">
					{translate key="plugins.themes.healthSciences.currentIssuePublished" date=$article->getDatePublished()|date_format:$dateFormatLong}
				</div>
			{/if}

		</div>
	</div><!-- .page-header -->

	<div class="row justify-content-md-center" id="mainArticleContent">
		<div class="col-lg-3 order-lg-2" id="articleDetailsWrapper">
			<div class="article-details-sidebar" id="articleDetails">

				{* Article/Issue cover image *}
				{if $article->getLocalizedCoverImage() || $issue->getLocalizedCoverImage()}
					<div class="article-details-block article-details-cover">
						{if $article->getLocalizedCoverImage()}
							<img class="img-fluid" src="{$article->getLocalizedCoverImageUrl()|escape}"{if $article->getLocalizedCoverImageAltText()} alt="{$article->getLocalizedCoverImageAltText()|escape}"{/if}>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img class="img-fluid" src="{$issue->getLocalizedCoverImageUrl()|escape}"{if $issue->getLocalizedCoverImageAltText()} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
							</a>
						{/if}
					</div>
				{/if}

				{* Pass author biographies to a global variable for use in footer.tpl *}
				{capture name="authorBiographyModals"}
					{foreach from=$authorBiographyModalsTemp item="modal"}
						{$modal}
					{/foreach}
				{/capture}


				{* Article Galleys (sidebar -- only visible on small devices) *}
				{if $primaryGalleys}
					<div class="article-details-block article-details-galleys article-details-galleys-sidebar">
						{foreach from=$primaryGalleys item=galley}
							<div class="article-details-galley">
								{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
							</div>
						{/foreach}
					</div>
				{/if}

				{* Supplementary galleys *}
				{if $showSupplements && $supplementaryGalleys}
					<div class="article-details-block article-details-galleys-supplementary">
						<h2 class="article-details-heading">{translate key="plugins.themes.healthSciences.article.supplementaryFiles"}</h2>
						{foreach from=$supplementaryGalleys item=galley}
							<div class="article-details-galley">
								{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley isSupplementary="1"}
							</div>
						{/foreach}
					</div>
				{/if}

				{* Keywords *}
				{if !empty($keywords[$currentLocale])}
					<div class="article-details-block article-details-keywords">
						<h2 class="article-details-heading">
							{translate key="article.subject"}
						</h2>
						<div class="article-details-keywords-value">
							{foreach from=$keywords item=keyword}
								{foreach name=keywords from=$keyword item=keywordItem}
									<span>{$keywordItem|escape}</span>{if !$smarty.foreach.keywords.last}<br>{/if}
								{/foreach}
							{/foreach}
						</div>
					</div>
				{/if}

				{* How to cite *}
				{if $citation}
					<div class="article-details-block article-details-how-to-cite">
						<h2 class="article-details-heading">
							{translate key="submission.howToCite"}
						</h2>
						<div id="citationOutput" class="article-details-how-to-cite-citation" role="region" aria-live="polite">
							{$citation}
						</div>
						<div class="dropdown">
							<button class="btn dropdown-toggle" type="button" id="cslCitationFormatsButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-csl-dropdown="true">
								{translate key="submission.howToCite.citationFormats"}
							</button>
							<div class="dropdown-menu" aria-labelledby="cslCitationFormatsButton">
								{foreach from=$citationStyles item="citationStyle"}
									<a
										class="dropdown-item"
										aria-controls="citationOutput"
										href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
										data-load-citation
										data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
									>
										{$citationStyle.title|escape}
									</a>
								{/foreach}
								{if count($citationDownloads)}
									<h3 class="dropdown-header">
										{translate key="submission.howToCite.downloadCitation"}
									</h3>
									{foreach from=$citationDownloads item="citationDownload"}
										<a class="dropdown-item" href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
											{$citationDownload.title|escape}
										</a>
									{/foreach}
								{/if}
							</div>
						</div>
					</div>
				{/if}

				{* PubIds (other than DOI; requires plugins) *}
				{foreach from=$pubIdPlugins item=pubIdPlugin}
					{if $pubIdPlugin->getPubIdType() == 'doi'}
						{php}continue;{/php}
					{/if}
					{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
					{if $pubId}
						<div class="article-details-block article-details-pubid">
							<h2 class="article-details-heading">
								{$pubIdPlugin->getPubIdDisplayType()|escape}
							</h2>
							<div class="article-details-pubid-value">
								{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
									<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
										{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
									</a>
								{else}
									{$pubId|escape}
								{/if}
							</div>
						</div>
					{/if}
				{/foreach}

				{call_hook name="Templates::Article::Details"}
			</div>
		</div>
		<div class="col-lg-9 order-lg-1" id="articleMainWrapper">
			<div class="article-details-main" id="articleMain">

				{* Abstract *}
				{if $article->getLocalizedAbstract()}
					<div class="article-details-block article-details-abstract">
						<h2 class="article-details-heading">{translate key="article.abstract"}</h2>
						{$article->getLocalizedAbstract()|strip_unsafe_html}
					</div>
				{/if}

				{* DOI for small screens only *}
				{foreach from=$pubIdPlugins item=pubIdPlugin}
					{if $pubIdPlugin->getPubIdType() != 'doi'}
						{php}continue;{/php}
					{/if}
					{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
					{if $pubId}
						{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
						<div class="article-details-block article-details-doi small-screen">
							<a href="{$doiUrl}">{$doiUrl}</a>
						</div>
					{/if}
				{/foreach}

				{* Article Galleys (bottom) *}
				{if $primaryGalleys}
					<div class="article-details-block article-details-galleys article-details-galleys-btm">
						{foreach from=$primaryGalleys item=galley}
							<div class="article-details-galley">
								{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
							</div>
						{/foreach}
					</div>
				{/if}

				{* References *}
				{if $parsedCitations->getCount() || $article->getCitations()}
					<div class="article-details-block article-details-references">
						<h2 class="article-details-heading">
							{translate key="submission.citations"}
						</h2>
						<div class="article-details-references-value">
							{if $parsedCitations->getCount()}
								{iterate from=parsedCitations item=parsedCitation}
									<p>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html}</p>
								{/iterate}
							{elseif $article->getCitations()}
								{$article->getCitations()|nl2br}
							{/if}
						</div>
					</div>
				{/if}

				{* Licensing info *}
				{if $copyright || $licenseUrl}
					<div class="article-details-block article-details-license">
						{if $licenseUrl}
						{if $ccLicenseBadge}
							{if $copyrightHolder}
								<p>{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}</p>
							{/if}
							{$ccLicenseBadge}
						{else}
							<a href="{$licenseUrl|escape}" class="copyright">
								{if $copyrightHolder}
									{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$copyright}
					</div>
				{/if}

				{call_hook name="Templates::Article::Main"}

			</div>
		</div>

		<div class="col-lg-12 order-lg-3 article-footer-hook">
			{call_hook name="Templates::Article::Footer::PageFooter"}
		</div>

	</div>
</div>
