{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showDatePublished bool Show the date this article was published?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}
{assign var=articlePath value=$article->getBestArticleId()}

{if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

<div class="article-summary">

	{if $article->getLocalizedCoverImage() && $showAuthor && $article->getPages()}
	<div class="article-summary-pic">
		<div class="cover media-left">
			<a href="{url page="article" op="view" path=$articlePath}" class="file">
				<img class="media-object" src="{$article->getLocalizedCoverImageUrl()|escape}">
			</a>
		</div>
	</div>
	<!--<div class="row">-->
		<div class="col authors">
			<div class="article-summary-authors" style="margin-left:-15px;">{$article->getAuthorString()}</div>
		</div>
		<!--<div class="col-3 col-md-2 col-lg-1">
			<div class="article-summary-pages text-right">
				{$article->getPages()|escape}
			</div>
		</div>
	</div>-->

	{elseif $article->getLocalizedCoverImage() && $showAuthor}
	<div class="article-summary-pic">
		<div class="cover media-left">
			<a href="{url page="article" op="view" path=$articlePath}" class="file">
				<img class="media-object" src="{$article->getLocalizedCoverImageUrl()|escape}">
			</a>
		</div>
	</div>
	<div class="col">
		<div class="article-summary-authors" style="margin-left:-15px;">{$article->getAuthorString()}</div>
	</div>

	{elseif $showAuthor && $article->getPages()}
	<div class="row">
		<div class="col">
			<div class="article-summary-authors">{$article->getAuthorString()}</div>
		</div>
		<!--<div class="col-3 col-md-2 col-lg-1">
			<div class="article-summary-pages text-right">
				{$article->getPages()|escape}
			</div>
		</div>-->
	</div>

	{elseif $showAuthor}
		<div class="article-summary-authors">{$article->getAuthorString()}</div>
	{elseif $article->getPages()}
		<div class="article-summary-pages">
			{$article->getPages()|escape}
		</div>
	{/if}


	<div class="article-summary-title">
		<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
			{$article->getLocalizedFullTitle()|escape}
		</a>
	</div>

	{if $showDatePublished && $article->getDatePublished()}
		<div class="article-summary-date">
			{$article->getDatePublished()|date_format:$dateFormatLong}
		</div>
	{/if}

	{if !$hideGalleys && $article->getGalleys()}
		<div class="article-summary-galleys">
			{foreach from=$article->getGalleys() item=galley}
				{if $primaryGenreIds}
					{assign var="file" value=$galley->getFile()}
					{if !$galley->getRemoteUrl() && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
						{php}continue;{/php}
					{/if}
				{/if}
				{assign var="hasArticleAccess" value=$hasAccess}
				{if ($article->getAccessStatus() == $smarty.const.ARTICLE_ACCESS_OPEN)}
					{assign var="hasArticleAccess" value=1}
				{/if}
				{include file="frontend/objects/galley_link.tpl" parent=$article hasAccess=$hasArticleAccess}
			{/foreach}
		</div>
	{/if}

	{call_hook name="Templates::Issue::Issue::Article"}
</div>
