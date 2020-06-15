// mock store for GlobalSettingsLayout
import React from 'react';
import GlobalSettingsLayout from '../index';
import PropTypes from 'prop-types';

function MockGlobalSettingsLayout(props) {
  return (
    <div>
      <GlobalSettingsLayout {...props} />
    </div>
  );
}

MockGlobalSettingsLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default MockGlobalSettingsLayout;
