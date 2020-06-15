import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation } from 'react-router-dom';

import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import { renderChildrenWithProps } from 'utils/componentHelpers';

import KPILinks from 'components/Group/GroupPlan/KPILinks';

const KPIPages = Object.freeze([
  // 'metrics', // NOT IMPLEMENTED YET
  'fields',
  'updates',
]);

const KPILayout = (props) => {
  const { classes, children, ...rest } = props;

  const location = useLocation();

  /* Get get first key that is in the path, ie: '/admin/system/settings/kpis/1/edit/ -> kpis */
  const currentPage = KPIPages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage || KPIPages[0]);

  useEffect(() => {
    if (tab !== currentPage && currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <KPILinks
        currentTab={tab}
        {...rest}
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

KPILayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  pageTitle: PropTypes.object,
};

export default compose(
  memo,
)(KPILayout);
