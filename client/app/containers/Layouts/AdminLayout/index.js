import React, { memo } from 'react';
import { compose } from 'redux';

import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';
import AdminLinks from 'components/Admin/AdminLinks';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import Scrollbar from 'components/Shared/Scrollbar';

import { renderChildrenWithProps } from 'utils/componentHelpers';

const styles = theme => ({
  flex: {
    display: 'flex',
    height: '100%',
    minHeight: 0,
  },
  toolbar: theme.mixins.toolbar,
  container: {
    overflow: 'hidden',
  },
  content: {
    padding: theme.spacing(3),
  },
  block: {
    display: 'block',
    overflow: 'hidden',
  },
  scrollbarContentContainer: {
    flexDirection: 'column',
    display: 'flex',
    width: '100%',
    height: '100%',
    overflow: 'hidden',
    minHeight: 0,
  },
});

export class AdminLayout extends React.PureComponent {
  render() {
    const { classes, ...rest } = this.props;

    return (
      <div className={classes.flex}>
        <AdminLinks />
        <div className={classes.scrollbarContentContainer}>
          <Scrollbar>
            <Fade in appear>
              <Container maxWidth='xl' className={classes.container}>
                <div className={classes.content}>
                  {renderChildrenWithProps(this.props.children, { ...rest })}
                </div>
              </Container>
            </Fade>
          </Scrollbar>
        </div>
      </div>
    );
  }
}

AdminLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
};

export default compose(
  memo,
  withStyles(styles),
)(AdminLayout);
