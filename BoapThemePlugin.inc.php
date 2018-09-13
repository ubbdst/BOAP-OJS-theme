<?php
import('lib.pkp.classes.plugins.ThemePlugin');
class BoapThemePlugin extends ThemePlugin {

    /**
     * Load the custom styles for our theme
     * @return null
     */
    public function init() {
        // Use the parent theme's unique plugin slug
        $this->setParent('healthsciencesthemeplugin');
        //$this->modifyStyle('stylesheet', array('addLess' => array('styles/index.less')));
        $this->addStyle('child-stylesheet', 'styles/index.less');

		$this->addOption('showSupplements', 'radio', array(
					   'label' => 'plugins.themes.boap.option.supplements.label',
					   'default' => False,
					   'options' => array(
							False => 'plugins.themes.boap.option.supplements.hide',
							True => 'plugins.themes.boap.option.supplements.show',
                       )
	    ));
		// Get extra data for templates
		HookRegistry::register ('TemplateManager::display', array($this, 'loadTemplateData'));
    }

    /**
     * Get the display name of this theme
     * @return string
     */
    function getDisplayName() {
        return 'BOAP Theme';
    }

    /**
     * Get the description of this plugin
     * @return string
     */
    function getDescription() {
        return 'BOAP Theme.';
    }

	public function loadTemplateData($hookName, $args) {
		$templateMgr = $args[0];
		$showSupplements = $this->getOption('showSupplements');
		$templateMgr->assign('showSupplements', $showSupplements);
	}
}