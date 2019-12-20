import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import GroupPlanLayout from '..';
import KPILinks from 'components/Group/GroupPlan/KPILinks';

const styles = theme => ({});

const KPIPages = Object.freeze({
  metrics: 0,
  fields: 1,
  updates: 2,
});

const KPILayout = ({ component: Component, ...rest }) => {
  const { classes, data, location, ...other } = rest;

  /* Get get first key that is in the path, ie: '/admin/system/settings/kpis/1/edit/ -> kpis */
  const currentPage = Object.keys(KPIPages).find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(KPIPages[currentPage]);

  useEffect(() => {
    if (tab !== KPIPages[currentPage])
      setTab(KPIPages[currentPage]);
  }, [currentPage]);

  return (
    <GroupPlanLayout
      {...rest}
      component={matchProps => (
        <React.Fragment>
          <KPILinks
            currentTab={tab}
            {...matchProps}
          />
          <Box mb={3} />
          <Fade in appear>
            <div>
              <Component {...other} />
            </div>
          </Fade>
        </React.Fragment>
      )}
    />
  );
};

KPILayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(KPILayout);
