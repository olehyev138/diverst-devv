import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation } from 'react-router-dom';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import EmailLinks from 'components/GlobalSettings/EmailLinks';
import { renderChildrenWithProps } from 'utils/componentHelpers';

const styles = theme => ({});

const EmailPages = Object.freeze([
  'layouts',
  'events',
]);

const EmailLayout = (props) => {
  const { classes, children, ...rest } = props;

  const location = useLocation();

  /* Get get first key that is in the path, ie: '/admin/system/settings/emails/1/edit/ -> emails */
  const currentPage = EmailPages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage || EmailPages[0]);

  useEffect(() => {
    if (tab !== currentPage && currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <EmailLinks
        currentTab={tab}
      />
      <Box mb={3} />
      <Fade in appear>
        <div>
          {renderChildrenWithProps(children, { ...rest })}
        </div>
      </Fade>
    </React.Fragment>
  );
};

EmailLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
};

export default compose(
  memo,
  withStyles(styles),
)(EmailLayout);
