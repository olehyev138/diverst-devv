import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import AdminLayout from '../AdminLayout';
import GlobalSettingsLinks from 'components/GlobalSettings/GlobalSettingsLinks';

const styles = theme => ({});

const GlobalSettingsPages = Object.freeze({
  fields: 0,
  custom_texts: 1,
  configuration: 2,
  sso: 3,
  email: 4,
});

const GlobalSettingsLayout = ({ component: Component, ...rest }) => {
  const { classes, data, location, ...other } = rest;

  /* Get get first key that is in the path, ie: '/admin/system/settings/emails/1/edit/ -> emails */
  const currentPage = Object.keys(GlobalSettingsPages).find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(GlobalSettingsPages[currentPage]);

  useEffect(() => {
    if (tab !== GlobalSettingsPages[currentPage])
      setTab(GlobalSettingsPages[currentPage]);
  }, [currentPage]);

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <GlobalSettingsLinks
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

GlobalSettingsLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(GlobalSettingsLayout);
