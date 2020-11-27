import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import RegionHome from 'components/Region/RegionHome';

export function RegionHomePage(props) {
  return (
    <RegionHome
      currentRegion={props.currentRegion}
    />
  );
}

RegionHomePage.propTypes = {
  currentRegion: PropTypes.object,
};

export default compose(
  memo,
)(RegionHomePage);
