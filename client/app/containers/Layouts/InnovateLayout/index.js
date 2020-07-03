import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation } from 'react-router-dom';

import Box from '@material-ui/core/Box';
import { withStyles } from '@material-ui/core/styles';

import InnovateLinks from 'components/Innovate/InnovateLinks';
import { renderChildrenWithProps } from 'utils/componentHelpers';

const styles = theme => ({});

const InnovatePages = Object.freeze({
  campaigns: 0,
  financials: 1
});

const InnovateLayout = (props) => {
  const { classes, children, ...rest } = props;

  const location = useLocation();

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();

  const [tab, setTab] = useState(InnovatePages[currentPagePath]);

  useEffect(() => {
    setTab(InnovatePages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <React.Fragment>
      <InnovateLinks
        currentTab={tab}
      />
      <Box mb={3} />
      {renderChildrenWithProps(children, { ...rest })}
    </React.Fragment>
  );
};

InnovateLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
};

export default compose(
  memo,
  withStyles(styles),
)(InnovateLayout);
