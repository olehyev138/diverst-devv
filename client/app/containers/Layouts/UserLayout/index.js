import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation } from 'react-router-dom';

import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';
import UserLinks from 'components/User/UserLinks';
import { withStyles } from '@material-ui/core/styles';

import Scrollbar from 'components/Shared/Scrollbar';
import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';

import { renderChildrenWithProps } from 'utils/componentHelpers';
import { customTexts } from 'utils/customTextHelpers';
import { findTitleForPath } from 'utils/routeHelpers';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const UserLayout = (props) => {
  const { classes, disableBreadcrumbs, children, ...rest } = props;

  const location = useLocation();
  // eslint-disable-next-line comma-spacing
  const [title,] = findTitleForPath({
    path: location.pathname,
    textArguments: customTexts(),
  });

  return (
    <React.Fragment>
      <UserLinks pageTitle={title} />
      <Scrollbar>
        <Fade in appear>
          <Container>
            <div className={classes.content}>
              {disableBreadcrumbs !== true ? (
                <DiverstBreadcrumbs />
              ) : (
                <React.Fragment />
              )}
              {renderChildrenWithProps(children, { ...rest })}
            </div>
          </Container>
        </Fade>
      </Scrollbar>
    </React.Fragment>
  );
};

UserLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  pageTitle: PropTypes.object,
  disableBreadcrumbs: PropTypes.bool,
};

export const StyledUserLayout = withStyles(styles)(UserLayout);

export default compose(
  memo,
  withStyles(styles),
)(UserLayout);
