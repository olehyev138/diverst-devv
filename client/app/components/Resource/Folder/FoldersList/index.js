/**
 *
 * Folders List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Tab, Paper, Card, CardContent, Grid, Link, Typography, Button, Hidden,
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import { FormattedMessage, injectIntl } from 'react-intl';
import messages from 'containers/Resource/Folder/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import Pagination from 'components/Shared/Pagination';

const styles = theme => ({
  folderListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  folderLink: {
    '&:hover': {
      textDecoration: 'none',
    },
    '&:hover h2': {
      textDecoration: 'underline',
    },
  },
  dateText: {
    fontWeight: 'bold',
  }
});

export function FoldersList(props, context) {
  const { classes, intl } = props;

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  const routeContext = useContext(RouteContext);

  const handleChangePage = (folder, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (folder) => {
    setRowsPerPage(+folder.target.value);
    props.handlePagination({ count: +folder.target.value, page });
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={props.links.folderNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={2} />

      <Grid container spacing={3}>
        { /* eslint-disable-next-line arrow-body-style */}
        {props.folders && Object.values(props.folders).map((item, i) => {
          return (
            <Grid item key={item.id} className={classes.folderListItem}>
              {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
              <Link
                className={classes.folderLink}
                component={WrappedNavLink}
                to={props.links.folderShow(item.id)}
              >
                <Card>
                  <CardContent>
                    <Grid container spacing={1} justify='space-between' alignItems='center'>
                      <Grid item xs>
                        <Typography color='primary' variant='h6' component='h2'>
                          {item.name}
                        </Typography>
                        <hr className={classes.divider} />
                        {item.description && (
                          <React.Fragment>
                            <Typography color='textSecondary'>
                              {item.description}
                            </Typography>
                            <Box pb={1} />
                          </React.Fragment>
                        )}
                      </Grid>
                      <Hidden xsDown>
                        <Grid item>
                          <KeyboardArrowRightIcon className={classes.arrowRight} />
                        </Grid>
                      </Hidden>
                    </Grid>
                  </CardContent>
                </Card>
              </Link>
            </Grid>
          );
        })}
        {props.folders && props.folders.length <= 0 && (
          <React.Fragment>
            <Grid item sm>
              <Box mt={3} />
              <Typography variant='h6' align='center' color='textSecondary'>
                <FormattedMessage {...messages.index.emptySection} />
              </Typography>
            </Grid>
          </React.Fragment>
        )}
      </Grid>
      {props.folders && props.folders.length > 0 && (
        <Pagination
          page={page}
          rowsPerPage={rowsPerPage}
          count={props.foldersTotal}
          onChangePage={handleChangePage}
          onChangeRowsPerPage={handleChangeRowsPerPage}
        />
      )}
    </React.Fragment>
  );
}

FoldersList.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  folders: PropTypes.array,
  foldersTotal: PropTypes.number,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(FoldersList);
