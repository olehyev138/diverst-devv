import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import GroupPlanLayout from '..';
import EmailLinks from 'components/GlobalSettings/EmailLinks';

const styles = theme => ({});

const EmailPages = Object.freeze({
  emailLayouts: 0,
  emailEvents: 1
});

const EmailLayout = ({ component: Component, ...rest }) => {
  const { classes, data, location, ...other } = rest;

  /* Get get first key that is in the path, ie: '/admin/system/settings/emails/1/edit/ -> emails */
  const currentPage = Object.keys(EmailPages).find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(EmailPages[currentPage]);

  useEffect(() => {
    if (tab !== EmailPages[currentPage])
      setTab(EmailPages[currentPage]);
  }, [currentPage]);

  return (
    <GroupPlanLayout
      {...rest}
      component={matchProps => (
        <React.Fragment>
          <EmailLinks
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

EmailLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(EmailLayout);
