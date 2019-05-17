/*
 * Events
 *
 * This is the first thing users see of our App, at the "/login" route
 */

import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";
import { withStyles } from "@material-ui/core/styles";

import Button from "@material-ui/core/Button";

import Typography from "@material-ui/core/Typography";
import Grid from "@material-ui/core/Grid";
import Card from "@material-ui/core/Card";
import CardActions from "@material-ui/core/CardActions";
import CardContent from "@material-ui/core/CardContent";

const styles = theme => ({
    paper: {
        padding: theme.spacing.unit * 2,
        textAlign: 'center',
        color: theme.palette.text.secondary,
    },
    card: {
        minWidth: 275
    },
    bullet: {
        display: "inline-block",
        margin: "0 2px",
        transform: "scale(0.8)"
    },
    pos: {
        marginBottom: 12
    }
});

export class Events extends React.PureComponent {
    
    constructor(props){
        super(props);
    }

    render() {
        const { classes } = this.props;
        const bull = <span className={classes.bullet}>•</span>;
        return (
            <div>
                    <Grid item style={{marginRight: 10}}>
                        <Card className={classes.card}>
                            <CardContent>
                                <Typography
                                    className={classes.title}
                                    color="textSecondary"
                                    gutterBottom
                                >
                                    Events You've Joined
                                </Typography>
                                <Typography variant="h5" component="h2">
                                    be
                                    {bull}
                                    nev
                                    {bull}o{bull}
                                    lent
                                </Typography>
                                <Typography
                                    className={classes.pos}
                                    color="textSecondary"
                                >
                                    adjective
                                </Typography>
                                <Typography component="p">
                                    well meaning and kindly.
                                    <br />
                                    {'"a benevolent smile"'}
                                </Typography>
                            </CardContent>
                            <CardActions>
                                <Button size="small">Learn More</Button>
                            </CardActions>
                        </Card>
                    </Grid>
            </div>
        );
    }
}

export function mapDispatchToProps(dispatch, ownProps) {
    return {
    };
}

const mapStateToProps = createStructuredSelector({
});

const withConnect = connect(
    mapStateToProps,
    mapDispatchToProps
);

export default compose(
    withConnect,
)(withStyles(styles)(Events));
